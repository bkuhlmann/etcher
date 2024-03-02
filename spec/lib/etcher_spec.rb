# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher do
  describe ".loader" do
    it "eager loads" do
      expectation = proc { described_class.loader.eager_load force: true }
      expect(&expectation).not_to raise_error
    end

    it "answers unique tag" do
      expect(described_class.loader.tag).to eq("etcher")
    end
  end

  describe ".new" do
    it "answers default builder instance" do
      expect(described_class.new).to be_a(described_class::Builder)
    end
  end

  describe ".call" do
    it "answers defaults when success" do
      expect(described_class.call).to eq({})
    end

    it "answers overrides when success" do
      expect(described_class.call(a: 1)).to eq(a: 1)
    end
  end
end
