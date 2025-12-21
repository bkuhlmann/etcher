# frozen_string_literal: true

require "dry/types"
require "versionaire"

module Etcher
  # Defines custom types.
  module Types
    include Dry.Types(default: :strict)

    Pathname = Constructor ::Pathname
    Version = Constructor Versionaire::Version, Versionaire.method(:Version)
  end
end
