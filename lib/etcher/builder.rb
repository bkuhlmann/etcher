# frozen_string_literal: true

require "core"
require "dry/monads"
require "refinements/hash"

module Etcher
  # Builds a configuration.
  class Builder
    include Dry::Monads[:result]

    using Refinements::Hash

    def initialize registry = Registry.new
      @registry = registry
    end

    def call(**overrides)
      load.then { |attributes| transform attributes }
          .fmap { |attributes| attributes.merge! overrides.symbolize_keys! }
          .bind { |attributes| validate attributes }
          .bind { |attributes| model attributes }
    end

    private

    attr_reader :registry

    def load
      registry.loaders
              .map { |loader| loader.call.fmap { |pairs| pairs.flatten_keys.symbolize_keys! } }
              .each
              .with_object({}) { |attributes, all| attributes.bind { |body| all.merge! body } }
              .then { |attributes| Success attributes }
    end

    def transform attributes
      registry.transformers.reduce attributes do |all, transformer|
        all.bind { |body| transformer.call body }
      end
    end

    def validate attributes
      registry.contract
              .call(attributes)
              .to_monad
              .or { |result| Failure step: __method__, payload: result.errors.to_h }
    end

    def model attributes
      Success registry.model[**attributes.to_h].freeze
    rescue ArgumentError => error
      Failure step: __method__, payload: "#{error.message.capitalize}."
    end
  end
end
