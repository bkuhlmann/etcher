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

    def add_loader(loader, *, **)
      if loader.is_a? Symbol
        self.class.find(:Loaders, loader).then { |constant| loaders.append constant.new(*, **) }
      else
        loaders.append loader
      end

      self
    end

    def add_transformer(transformer, *, **)
      if transformer.is_a? Symbol
        self.class.find(:Transformers, transformer).then do |constant|
          transformers.append constant.new(*, **)
        end
      else
        transformers.append transformer
      end

      self
    end
  end
end
