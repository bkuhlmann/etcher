# frozen_string_literal: true

require "dry/monads"
require "refinements/array"

module Etcher
  # Builds and fully resolves a configuration.
  class Resolver
    include Dry::Monads[:result]

    using Refinements::Array

    def initialize registry = Registry.new, logger: LOGGER
      @builder = Builder.new registry
      @logger = logger
    end

    def call(**overrides)
      case builder.call(**overrides)
        in Success(attributes) then attributes
        in Failure(step:, constant:, payload: String => payload)
          logger.abort "#{step.capitalize} failure (#{constant}). #{payload}"
        in Failure(step:, constant:, payload: Hash => payload)
          log_and_abort step, constant, payload
        in Failure(String => message) then logger.abort message
        else logger.abort "Unable to parse failure."
      end
    end

    private

    attr_reader :builder, :logger

    def log_and_abort step, constant, errors
      details = errors.map { |key, message| "  - #{key} #{message.to_sentence}\n" }
                      .join

      logger.abort "#{step.capitalize} failure (#{constant}). " \
                   "Unable to load configuration:\n#{details}"
    end
  end
end
