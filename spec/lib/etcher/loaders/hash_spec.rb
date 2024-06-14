# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::Hash do
  include Dry::Monads[:result]

  subject(:loader) { described_class.new }

  describe "#call" do
    it "answers empty hash by default" do
      expect(loader.call).to eq(Success({}))
    end

    it "answers custom hash" do
      loader = described_class.new one: 1, two: 2, three: 3
      expect(loader.call).to eq(Success({one: 1, two: 2, three: 3}))
    end
  end
end
