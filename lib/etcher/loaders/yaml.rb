# frozen_string_literal: true

require "core"
require "dry/monads"
require "yaml"

module Etcher
  module Loaders
    # Loads a YAML configuration.
    class YAML
      include Dry::Monads[:result]

      def initialize path, fallback: Core::EMPTY_HASH, logger: LOGGER
        @path = path
        @fallback = fallback
        @logger = logger
      end

      def call
        load
      rescue TypeError, Errno::ENOENT
        debug_and_fallback "Invalid path: #{path_info}. Using fallback."
      rescue Psych::Exception => error
        debug_and_fallback "#{error.message}. Path: #{path_info}. Using fallback."
      end

      private

      attr_reader :path, :fallback, :logger

      def load
        content = ::YAML.safe_load_file path

        return Success content if content.is_a? Hash

        debug_and_fallback "Invalid content: #{content.inspect}. Using fallback."
      end

      def path_info = path.to_s.inspect

      def debug_and_fallback message
        logger.debug { message }
        Success fallback
      end
    end
  end
end
