# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher do
  describe ".new" do
    it "answers default builder instance" do
      expect(described_class.new).to be_a(Etcher::Builder)
    end
  end

  describe ".call" do
    it "answers defaults when success" do
      expect(described_class.call).to eq({})
    end

    it "answers overrides when success" do
      expect(described_class.call(a: 1)).to eq(a: 1)
    end
  end
end
