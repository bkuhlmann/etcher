# frozen_string_literal: true

require "cogger"
require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.push_dir __dir__
  loader.inflector.inflect "json" => "JSON", "yaml" => "YAML"
  loader.tag = File.basename __FILE__, ".rb"
  loader.setup
end

# Main namespace.
module Etcher
  LOGGER = Cogger.new id: :etcher, formatter: :emoji

  def self.loader(registry = Zeitwerk::Registry) = registry.loader_for __FILE__

  def self.new(...) = Builder.new(...)

  def self.call(registry = Registry.new, **) = Resolver.new(registry).call(**)
end
