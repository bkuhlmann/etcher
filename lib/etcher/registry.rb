# frozen_string_literal: true

module Etcher
  # Provides a registry of customization for loading and resolving a configuration.
  Registry = Data.define :contract, :model, :loaders, :transformers do
    def initialize contract: Contract, model: Hash, loaders: [], transformers: []
      super
    end

    def add_loader loader
      loaders.append loader
      self
    end

    def add_transformer transformer
      transformers.append transformer
      self
    end
  end
end
