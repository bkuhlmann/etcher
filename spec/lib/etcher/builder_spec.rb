# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Builder do
  include Dry::Monads[:result]

  subject(:builder) { described_class.new }

  describe "#initialize" do
    it "is frozen" do
      expect(builder.frozen?).to be(true)
    end
  end

  describe "#call" do
    let(:registry) { Etcher::Registry[contract:, model:] }
    let(:contract) { Dry::Schema.Params { required(:name).filled :string } }
    let(:model) { Data.define :name }

    it "answers empty hash by default" do
      expect(builder.call).to eq(Success({}))
    end

    it "answers frozen hash by default" do
      expect(builder.call.success.frozen?).to be(true)
    end

    it "answers last loader key with multiple loaders" do
      registry = Etcher::Registry.new
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/one.json")
      registry.add_loader :yaml, SPEC_ROOT.join("support/fixtures/two.yaml")
      builder = described_class.new registry

      expect(builder.call).to eq(Success(name: "two"))
    end

    it "answers last nested loader key with multiple loaders" do
      registry = Etcher::Registry.new
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/three.json")
      registry.add_loader :yaml, SPEC_ROOT.join("support/fixtures/four.yaml")
      builder = described_class.new registry

      expect(builder.call).to eq(Success(test_name: "four"))
    end

    it "answers mixed keys with multiple loaders" do
      registry = Etcher::Registry.new
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/one.json")
      registry.add_loader :yaml, SPEC_ROOT.join("support/fixtures/four.yaml")
      builder = described_class.new registry

      expect(builder.call).to eq(Success(name: "one", test_name: "four"))
    end

    it "answers last loader key with multiple loaders and overrides" do
      registry = Etcher::Registry.new
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/three.json")
      registry.add_loader :yaml, SPEC_ROOT.join("support/fixtures/four.yaml")
      builder = described_class.new registry
      result = builder.call test_name: "one", other: "two"

      expect(result).to eq(Success({test_name: "one", other: "two"}))
    end

    it "fails to load" do
      registry = Etcher::Registry.new
      registry.add_loader proc { Failure "Danger!" }
      builder = described_class.new registry

      expect(builder.call).to eq(Failure("Danger!"))
    end

    it "fails to transform" do
      registry = Etcher::Registry.new
      registry.add_transformer(proc { Failure "Danger!" })
      builder = described_class.new registry

      expect(builder.call).to eq(Failure("Danger!"))
    end

    it "answers symbol overrides" do
      attributes = {name: "test", label: "Test"}
      expect(builder.call(**attributes)).to eq(Success(attributes))
    end

    it "answers string overrides" do
      attributes = {"name" => "test", "label" => "Test"}
      expect(builder.call(**attributes)).to eq(Success(name: "test", label: "Test"))
    end

    it "answers contract failure with invalid overrides" do
      builder = described_class.new registry

      expect(builder.call(label: "Test")).to eq(
        Failure(step: :validate, constant: described_class, payload: {name: ["is missing"]})
      )
    end

    it "answers Data record" do
      model = Data.define :name
      registry = Etcher::Registry[model:]
      builder = described_class.new registry

      expect(builder.call(name: "test")).to eq(Success(model[name: "test"]))
    end

    it "answers Data argument failure" do
      registry = Etcher::Registry[model: Data.define(:other)]
      builder = described_class.new registry

      expect(builder.call(name: "test")).to eq(
        Failure(step: :model, constant: described_class, payload: "Unknown keyword: :name.")
      )
    end

    it "answers Struct model" do
      model = Struct.new :name
      registry = Etcher::Registry[model:]
      builder = described_class.new registry

      expect(builder.call(name: "test")).to eq(Success(model[name: "test"]))
    end

    it "answers Struct argument failure" do
      registry = Etcher::Registry[model: Struct.new(:other)]
      builder = described_class.new registry

      expect(builder.call(name: "test")).to eq(
        Failure(step: :model, constant: described_class, payload: "Unknown keywords: name.")
      )
    end

    it "answers record for custom loaders, transforms, contract, and model" do
      registry = Etcher::Registry[contract:, model:]
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/one.json")
      registry.add_transformer(-> pairs { Success pairs.merge!(name: pairs[:name].upcase) })
      registry.add_transformer(-> pairs { Success pairs.merge!(name: "#{pairs[:name]}!") })
      builder = described_class.new registry

      expect(builder.call).to eq(Success(model[name: "ONE!"]))
    end

    it "answers record for custom loaders, transforms, overrides, contract, and model" do
      registry = Etcher::Registry[contract:, model:]
      registry.add_loader :json, SPEC_ROOT.join("support/fixtures/one.json")
      registry.add_transformer(-> pairs { Success pairs.merge!(name: pairs[:name].upcase) })
      registry.add_transformer(-> pairs { Success pairs.merge!(name: "#{pairs[:name]}!") })
      builder = described_class.new registry

      expect(builder.call(name: "test")).to eq(Success(model[name: "test"]))
    end
  end
end
