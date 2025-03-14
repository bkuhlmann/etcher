# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::Environment do
  subject(:loader) { described_class.new attributes }

  let :attributes do
    {
      "HOME" => "/Users/test",
      "RACK_ENV" => "test",
      "USER" => "test"
    }
  end

  describe "#initialize" do
    it "is frozen" do
      expect(loader.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers empty hash by default" do
      expect(loader.call).to be_success({})
    end

    it "answers filtered, empty hash with no matches" do
      loader = described_class.new attributes, only: "user"
      expect(loader.call).to be_success({})
    end

    it "answers filtered hash with matches" do
      loader = described_class.new attributes, only: %w[HOME USER]
      expect(loader.call).to be_success("home" => "/Users/test", "user" => "test")
    end

    it "answers filtered, downcased hash with matches" do
      loader = described_class.new attributes, only: %w[HOME RACK_ENV USER]

      expect(loader.call).to be_success(
        "home" => "/Users/test", "rack_env" => "test", "user" => "test"
      )
    end
  end
end
