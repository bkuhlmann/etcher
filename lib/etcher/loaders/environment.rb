# frozen_string_literal: true

require "core"
require "dry/monads"

module Etcher
  module Loaders
    # Loads environment configuration with optional includes.
    class Environment
      include Dry::Monads[:result]

      def initialize includes = Core::EMPTY_ARRAY, source: ENV
        @includes = Array includes
        @source = source
      end

      def call = Success source.slice(*includes).transform_keys(&:downcase)

      private

      attr_reader :includes, :source
    end
  end
end
