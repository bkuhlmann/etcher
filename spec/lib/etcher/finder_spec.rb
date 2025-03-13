# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Finder do
  subject(:finder) { described_class }

  describe "#call" do
    it "answers selected constant" do
      expect(finder.call(:Loaders, :json)).to be_success(Etcher::Loaders::JSON)
    end

    it "answers failure when moniker can't be found" do
      expect(finder.call(:Loaders, :bogus)).to be_failure("Unable to select :bogus within loaders.")
    end

    it "answers failure when namespace is invalid" do
      expect(finder.call(:bogus, :json)).to be_failure("Invalid namespace: :bogus.")
    end
  end
end
