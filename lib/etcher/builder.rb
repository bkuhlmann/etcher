# frozen_string_literal: true

require "core"
require "dry/monads"
require "refinements/hashes"

module Etcher
  # Builds a configuration.
  class Builder
    include Dry::Monads[:result]

    using Refinements::Hashes

    def initialize registry = Registry.new
      @registry = registry
    end

    def call(**overrides)
      load(overrides.symbolize_keys!).then { |content| transform content }
                                     .bind { |content| validate content }
                                     .bind { |content| record content }
    end

    private

    attr_reader :registry

    # :reek:NestedIterators
    # :reek:TooManyStatements
    def load overrides
      registry.loaders
              .map { |loader| loader.call.fmap { |content| content.flatten_keys.symbolize_keys! } }
              .each
              .with_object({}) { |content, all| content.bind { |body| all.merge! body } }
              .merge!(overrides.flatten_keys)
              .then { |content| Success content }
    end

    # :reek:NestedIterators
    def transform content
      registry.transformers.reduce content do |all, transformer|
        all.bind { |body| transformer.call body }
      end
    end

    def validate content
      registry.contract
              .call(content)
              .to_monad
              .or { |result| Failure(step: __method__, payload: result.errors.to_h) }
    end

    def record content
      Success registry.model[**content.to_h].freeze
    rescue ArgumentError => error
      Failure step: __method__, payload: "#{error.message.capitalize}."
    end
  end
end
