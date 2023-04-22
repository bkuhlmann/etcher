# frozen_string_literal: true

require "cogger"
require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

# Main namespace.
module Etcher
  LOGGER = Cogger.new id: :etcher, formatter: :emoji
end
