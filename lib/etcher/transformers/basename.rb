# frozen_string_literal: true

require "dry/monads"
require "refinements/hash"

module Etcher
  module Transformers
    # Conditionally updates value based on path.
    class Basename
      include Dry::Monads[:result]

      using Refinements::Hash

      def initialize key, fallback: Pathname.pwd.basename.to_s
        @key = key
        @fallback = fallback
        freeze
      end

      def call attributes
        attributes.fetch_value(key) { attributes.merge! key => fallback }
        Success attributes
      end

      private

      attr_reader :key, :fallback
    end
  end
end
