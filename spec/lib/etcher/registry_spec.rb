# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Registry do
  subject(:registry) { described_class.new }

  describe ".find" do
    it "answers constant when found" do
      expect(described_class.find(:Loaders, :json)).to eq(Etcher::Loaders::JSON)
    end

    it "aborts when failure" do
      logger = instance_spy Cogger::Hub
      described_class.find(:Loaders, :bogus, logger:)

      expect(logger).to have_received(:abort).with("Unable to select :bogus within loaders.")
    end

    it "aborts when unable to find constant" do
      allow(Etcher::Finder).to receive(:call).and_return "Danger!"
      logger = instance_spy Cogger::Hub
      described_class.find(:bogus, :bogus, logger:)

      expect(logger).to have_received(:abort).with("Unable to find constant in registry.")
    end
  end

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
    it "adds loader (symbol)" do
      registry.add_loader :json, "test.json"
      expect(registry.loaders).to contain_exactly(kind_of(Etcher::Loaders::JSON))
    end

    it "adds loader (instance)" do
      loader = Etcher::Loaders::JSON.new "test.json"
      registry.add_loader loader

      expect(registry.loaders).to eq([loader])
    end

    it "answers itself" do
      expect(registry.add_loader(Object)).to be_a(described_class)
    end
  end

  describe "#remove_loader" do
    before { registry.add_loader :json, "test.json" }

    it "removes loader" do
      registry.remove_loader 0
      expect(registry.loaders).to eq([])
    end

    it "answers itself" do
      expect(registry.remove_loader(0)).to be_a(described_class)
    end
  end

  describe "#loaders" do
    it "answers default loaders" do
      expect(registry.loaders).to eq([])
    end
  end

  describe "#add_transformer" do
    it "adds transformer (symbol)" do
      registry.add_transformer :time, :now
      expect(registry.transformers).to contain_exactly(kind_of(Etcher::Transformers::Time))
    end

    it "adds transformer (instance)" do
      transformer = proc { "test" }
      registry.add_transformer transformer

      expect(registry.transformers).to eq([transformer])
    end

    it "answers itself" do
      expect(registry.add_transformer(Object)).to be_a(described_class)
    end
  end

  describe "#remove_transformer" do
    before { registry.add_transformer :time, :now }

    it "removes transformer" do
      registry.remove_transformer 0
      expect(registry.transformers).to eq([])
    end

    it "answers itself" do
      expect(registry.remove_transformer(0)).to be_a(described_class)
    end
  end

  describe "#transformers" do
    it "answers default transformers" do
      expect(registry.transformers).to eq([])
    end
  end
end
