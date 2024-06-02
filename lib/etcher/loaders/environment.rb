# frozen_string_literal: true

require "core"
require "dry/monads"

module Etcher
  module Loaders
    # Loads environment configuration with optional includes.
    class Environment
      include Dry::Monads[:result]

      def initialize attributes = ENV, only: Core::EMPTY_ARRAY
        @attributes = attributes
        @only = Array only
      end

      def call = Success attributes.slice(*only).transform_keys(&:downcase)

      private

      attr_reader :attributes, :only
    end
  end
end
