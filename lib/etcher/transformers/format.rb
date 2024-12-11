# frozen_string_literal: true

require "dry/monads"

module Etcher
  module Transformers
    # Formats given key using existing and/or placeholder attributes.
    class Format
      include Dry::Monads[:result]

      def initialize key, *retainers, **mappings
        @key = key
        @retainers = retainers
        @mappings = mappings
        @pattern = /%<.+>s/o
        freeze
      end

      def call attributes
        value = attributes[key]

        return Success attributes unless value && value.match?(pattern)

        Success attributes.merge!(key => format(value, **attributes, **pass_throughs))
      rescue KeyError => error
        Failure step: :transform,
                constant: self.class,
                payload: "Unable to transform #{key.inspect}, missing specifier: " \
                         "\"#{error.message[/<.+>/]}\"."
      end

      private

      attr_reader :key, :retainers, :mappings, :pattern

      def pass_throughs
        retainers.each
                 .with_object({}) { |key, expansions| expansions[key] = "%<#{key}>s" }
                 .merge! mappings
      end
    end
  end
end
