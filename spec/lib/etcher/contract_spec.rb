# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Contract do
  subject(:contract) { described_class }

  describe "#call" do
    let(:attributes) { {name: "test"} }

    it "passes attributes through" do
      expect(contract.call(attributes)).to eq(name: "test")
    end

    it "doesn't define monad method multiple times" do
      contract.call attributes
      expect(contract.call(attributes)).to eq(name: "test")
    end

    it "can be cast as a monad" do
      expect(contract.call(attributes).to_monad).to be_success(name: "test")
    end
  end
end
