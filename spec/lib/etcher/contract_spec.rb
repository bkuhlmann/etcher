# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Contract do
  include Dry::Monads[:result]

  subject(:contract) { described_class }

  describe "#call" do
    let(:content) { {name: "test"} }

    it "passes content through" do
      expect(contract.call(content)).to eq(name: "test")
    end

    it "doesn't define monad method multiple times" do
      contract.call content
      expect(contract.call(content)).to eq(name: "test")
    end

    it "can be cast to a monad" do
      expect(contract.call(content).to_monad).to eq(Success(name: "test"))
    end
  end
end
