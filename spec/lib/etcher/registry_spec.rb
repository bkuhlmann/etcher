# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Registry do
  subject(:registry) { described_class.new }

  describe "#initialize" do
    it "answers defaults" do
      expect(registry).to have_attributes(
        contract: Etcher::Contract,
        model: Hash,
        loaders: [],
        transformers: []
      )
    end
  end

  describe "#add_loader" do
    it "adds loader" do
      loader = Etcher::Loaders::JSON.new "test.json"
      registry.add_loader loader

      expect(registry.loaders).to eq([loader])
    end

    it "answers itself" do
      expect(registry.add_loader(Object)).to be_a(described_class)
    end
  end

  describe "#loaders" do
    it "answers default loaders" do
      expect(registry.loaders).to eq([])
    end
  end

  describe "#add_transformer" do
    it "adds transformer" do
      transformer = proc { "test" }
      registry.add_transformer transformer

      expect(registry.transformers).to eq([transformer])
    end

    it "answers itself" do
      expect(registry.add_transformer(Object)).to be_a(described_class)
    end
  end

  describe "#transformers" do
    it "answers default transformers" do
      expect(registry.transformers).to eq([])
    end
  end
end
