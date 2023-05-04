# frozen_string_literal: true

require "dry/types"
require "pathname"

module Etcher
  # Defines custom types.
  module Types
    include Dry.Types(default: :strict)

    Pathname = Constructor ::Pathname
  end
end
