# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::Environment do
  include Dry::Monads[:result]

  subject(:loader) { described_class.new source: }

  let :source do
    {
      "HOME" => "/Users/test",
      "RACK_ENV" => "test",
      "USER" => "test"
    }
  end

  describe "#call" do
    it "answers empty hash with empty includes" do
      expect(loader.call).to eq(Success({}))
    end

    it "answers filtered hash with matching includes" do
      loader = described_class.new(%w[HOME USER], source:)
      expect(loader.call).to eq(Success("home" => "/Users/test", "user" => "test"))
    end

    it "answers downcased keys with matching includes" do
      loader = described_class.new(%w[HOME RACK_ENV USER], source:)

      expect(loader.call).to eq(
        Success("home" => "/Users/test", "rack_env" => "test", "user" => "test")
      )
    end

    it "answers empty hash with no matching includes" do
      loader = described_class.new("user", source:)
      expect(loader.call).to eq(Success({}))
    end
  end
end
