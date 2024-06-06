# frozen_string_literal: true

module Etcher
  # Provides a registry of customization for loading and resolving a configuration.
  Registry = Data.define :contract, :model, :loaders, :transformers do
    def self.find namespace, moniker, logger: LOGGER
      case Finder.call namespace, moniker
        in Success(constant) then constant
        in Failure(message) then logger.abort message
        else logger.abort "Unable to find constant in registry."
      end
    end

    def initialize contract: Contract, model: Hash, loaders: [], transformers: []
      super
    end

    def add_loader(loader, ...) = add(loader, :Loaders, ...)

    def remove_loader(index) = remove index, loaders

    def add_transformer(transformer, ...) = add(transformer, :Transformers, ...)

    def remove_transformer(index) = remove index, transformers

    private

    def add(item, namespace, ...)
      collection = __send__ namespace.downcase

      if item.is_a? Symbol
        self.class.find(namespace, item).then { |kind| collection.append kind.new(...) }
      else
        collection.append item
      end

      self
    end

    def remove index, collection
      collection.delete_at index
      self
    end
  end
end
