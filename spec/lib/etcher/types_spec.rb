# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Types do
  using Versionaire::Cast

  describe "Pathname" do
    subject(:type) { described_class::Pathname }

    it "answers primitive" do
      expect(type.primitive).to eq(Pathname)
    end

    it "answers pathname" do
      expect(type.call("a/path")).to eq(Pathname("a/path"))
    end
  end

  describe "Version" do
    subject(:type) { described_class::Version }

    it "answers primitive" do
      expect(type.primitive).to eq(Versionaire::Version)
    end

    it "answers version" do
      expect(type.call("0.0.0")).to eq(Version("0.0.0"))
    end
  end
end
