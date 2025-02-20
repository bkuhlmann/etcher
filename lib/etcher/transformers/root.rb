# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/hash"

module Etcher
  module Transformers
    # Conditionally updates value based on path.
    class Root
      include Dry::Monads[:result]

      using Refinements::Hash

      def initialize key, fallback: Pathname.pwd
        @key = key
        @fallback = fallback
        freeze
      end

      def call attributes
        value = attributes.fetch_value(key) { fallback }
        Success attributes.merge!(key => Pathname(value).expand_path)
      end

      private

      attr_reader :key, :fallback
    end
  end
end
