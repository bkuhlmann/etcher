# frozen_string_literal: true

require "cogger"
require "zeitwerk"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "json" => "JSON", "yaml" => "YAML"
  loader.setup
end

# Main namespace.
module Etcher
  LOGGER = Cogger.new id: :etcher, formatter: :emoji

  def self.new(...) = Builder.new(...)

  def self.call(registry = Registry.new, **) = Resolver.new(registry).call(**)
end
