# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Types do
  describe "Pathname" do
    subject(:type) { described_class::Pathname }

    it "answers primitive" do
      expect(type.primitive).to eq(Pathname)
    end

    it "answers pathname" do
      expect(type.call("a/path")).to eq(Pathname("a/path"))
    end
  end
end
