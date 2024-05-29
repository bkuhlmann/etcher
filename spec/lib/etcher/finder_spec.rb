# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Finder do
  include Dry::Monads[:result]

  subject(:finder) { described_class }

  describe "#call" do
    it "answers selected constant" do
      expect(finder.call(:Loaders, :json)).to eq(Success(Etcher::Loaders::JSON))
    end

    it "answers failure when moniker can't be found" do
      expect(finder.call(:Loaders, :bogus)).to eq(
        Failure("Unable to select :bogus within loaders.")
      )
    end

    it "answers failure when namespace is invalid" do
      expect(finder.call(:bogus, :json)).to eq(Failure("Invalid namespace: :bogus."))
    end
  end
end
