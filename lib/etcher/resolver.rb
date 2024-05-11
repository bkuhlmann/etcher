# frozen_string_literal: true

require "dry/monads"
require "refinements/array"

module Etcher
  # Builds and fully resolves a configuration.
  class Resolver
    include Dry::Monads[:result]

    using Refinements::Array

    def initialize registry = Registry.new, kernel: Kernel, logger: LOGGER
      @builder = Builder.new registry
      @kernel = kernel
      @logger = logger
    end

    def call(**overrides)
      case builder.call(**overrides)
        in Success(attributes) then attributes
        in Failure(step:, payload: String => payload)
          logger.fatal { "Build failure: #{step.inspect}. #{payload}" }
          kernel.abort
        in Failure(step:, payload: Hash => payload) then log_and_abort payload
        else fail StandardError, "Unable to parse configuration."
      end
    end

    private

    attr_reader :builder, :kernel, :logger

    def log_and_abort errors
      logger.fatal do
        details = errors.map { |key, message| "  - #{key} #{message.to_sentence}\n" }
                        .join
        "Unable to load configuration due to the following issues:\n#{details}"
      end

      kernel.abort
    end
  end
end
