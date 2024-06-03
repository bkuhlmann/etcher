# frozen_string_literal: true

require "dry/monads"

module Etcher
  module Transformers
    # Conditionally transforms current time for key.
    class Time
      include Dry::Monads[:result]

      def initialize key = :loaded_at, fallback: ::Time.now.utc
        @key = key
        @fallback = fallback
      end

      def call attributes
        attributes.fetch(key) { attributes.merge! key => fallback }
        Success attributes
      end

      private

      attr_reader :key, :fallback
    end
  end
end
