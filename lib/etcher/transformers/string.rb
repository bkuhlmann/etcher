# frozen_string_literal: true

require "dry/monads"

module Etcher
  module Transformers
    # Formats given key using existing and/or ancillary attributes.
    class String
      include Dry::Monads[:result]

      def initialize key, **ancillary
        @key = key
        @ancillary = ancillary
      end

      def call attributes
        value = attributes[key]

        return Success attributes unless value

        Success attributes.merge(key => format(value, **attributes, **ancillary))
      rescue KeyError => error
        Failure step: :transform,
                constant: self.class,
                payload: "Unable to transform #{key.inspect}, missing specifier: " \
                         "\"#{error.message[/<.+>/]}\"."
      end

      private

      attr_reader :key, :ancillary
    end
  end
end
