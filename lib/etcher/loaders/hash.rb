# frozen_string_literal: true

require "dry/monads"

module Etcher
  module Loaders
    # Loads (wraps) raw attributes.
    class Hash
      include Dry::Monads[:result]

      def initialize(**attributes)
        @attributes = attributes
      end

      def call = Success attributes

      private

      attr_reader :attributes
    end
  end
end
