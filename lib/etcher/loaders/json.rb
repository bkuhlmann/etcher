# frozen_string_literal: true

require "core"
require "dry/monads"
require "json"

module Etcher
  module Loaders
    # Loads a JSON configuration.
    class JSON
      include Dry::Monads[:result]

      def initialize path, fallback: Core::EMPTY_HASH, logger: LOGGER
        @path = path
        @fallback = fallback
        @logger = logger
      end

      def call
        Success ::JSON.load_file(path)
      rescue TypeError, Errno::ENOENT
        debug_and_fallback "Invalid path: #{path_info}. Using fallback."
      rescue ::JSON::ParserError => error
        debug_and_fallback "#{error.message}. Path: #{path_info}. Using fallback."
      end

      private

      attr_reader :path, :fallback, :logger

      def path_info = path.to_s.inspect

      def debug_and_fallback message
        logger.debug { message }
        Success fallback
      end
    end
  end
end
