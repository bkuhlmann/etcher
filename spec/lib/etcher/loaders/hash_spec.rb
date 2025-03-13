# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::Hash do
  subject(:loader) { described_class.new }

  describe "#initialize" do
    it "is frozen" do
      expect(loader.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers empty hash by default" do
      expect(loader.call).to be_success({})
    end

    it "answers custom hash" do
      loader = described_class.new one: 1, two: 2, three: 3
      expect(loader.call).to be_success(one: 1, two: 2, three: 3)
    end
  end
end
