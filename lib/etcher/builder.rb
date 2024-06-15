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
      load.bind { |attributes| transform attributes }
          .fmap { |attributes| attributes.merge! overrides.symbolize_keys! }
          .bind { |attributes| validate attributes }
          .bind { |attributes| model attributes }
    end

    private

    attr_reader :registry

    def load
      registry.loaders
              .map { |loader| loader.call.fmap { |pairs| pairs.flatten_keys.symbolize_keys! } }
              .reduce(Success({})) { |all, result| merge all, result }
    end

    def transform attributes
      registry.transformers.reduce Success(attributes) do |all, transformer|
        merge all, transformer.call(attributes)
      end
    end

    def validate attributes
      registry.contract
              .call(attributes)
              .to_monad
              .or do |result|
                Failure step: __method__, constant: self.class, payload: result.errors.to_h
              end
    end

    def model attributes
      Success registry.model[**attributes.to_h].freeze
    rescue ArgumentError => error
      Failure step: __method__, constant: self.class, payload: "#{error.message.capitalize}."
    end

    def merge(*items)
      case items
        in Success(all), Success(subset) then Success(all.merge!(subset))
        else items.last
      end
    end
  end
end
