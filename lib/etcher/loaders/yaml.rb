# frozen_string_literal: true

require "core"
require "dry/monads"
require "refinements/string"
require "yaml"

module Etcher
  module Loaders
    # Loads a YAML configuration.
    class YAML
      include Dry::Monads[:result]

      using Refinements::String

      def initialize path, fallback: Core::EMPTY_HASH, logger: LOGGER
        @path = path
        @fallback = fallback
        @logger = logger
      end

      def call
        load
      rescue Errno::ENOENT, TypeError then debug_invalid_path
      rescue Psych::AliasesNotEnabled then alias_failure
      rescue Psych::DisallowedClass => error then disallowed_failure error
      rescue Psych::SyntaxError => error then syntax_failure error
      end

      private

      attr_reader :path, :fallback, :logger

      def load
        content = ::YAML.safe_load_file path

        case content
          in ::Hash then Success content
          in nil then empty_failure
          else invalid_failure content
        end
      end

      def debug_invalid_path
        logger.debug { "Invalid path: #{path_info}. Using fallback." }
        Success fallback
      end

      def empty_failure
        Failure step: :load, constant: self.class, payload: "File is empty: #{path_info}."
      end

      def invalid_failure content
        Failure step: :load,
                constant: self.class,
                payload: "Invalid content: #{content.inspect}. Path: #{path_info}."
      end

      def alias_failure
        Failure step: :load,
                constant: self.class,
                payload: "Aliases are disabled, please remove. Path: #{path_info}."
      end

      def disallowed_failure error
        Failure step: :load,
                constant: self.class,
                payload: "Invalid type, #{error.message.down}. Path: #{path_info}."
      end

      def syntax_failure error
        Failure step: :load,
                constant: self.class,
                payload: "Invalid syntax, #{error.message[/found.+/]}. " \
                         "Path: #{path_info}."
      end

      def path_info = path.to_s.inspect
    end
  end
end
