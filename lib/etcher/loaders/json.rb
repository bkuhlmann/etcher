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
      rescue Errno::ENOENT, TypeError then debug_invalid_path
      rescue ::JSON::ParserError => error then content_failure error
      end

      private

      attr_reader :path, :fallback, :logger

      def debug_invalid_path
        logger.debug { "Invalid path: #{path_info}. Using fallback." }
        Success fallback
      end

      def content_failure error
        constant = self.class
        token = error.message[/(?<token>'.+?')/, :token].to_s.tr "'", ""

        if token.empty?
          Failure step: :load, constant:, payload: "File is empty: #{path_info}."
        else
          Failure step: :load,
                  constant:,
                  payload: "Invalid content: #{token.inspect}. Path: #{path_info}."
        end
      end

      def path_info = path.to_s.inspect
    end
  end
end
