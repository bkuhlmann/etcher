# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Transformers::Root do
  subject(:transformer) { described_class.new :root }

  describe "#initialize" do
    it "is frozen" do
      expect(transformer.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers expanded path when key exists" do
      expect(transformer.call({root: "test"})).to be_success(root: Bundler.root.join("test"))
    end

    it "answers expanded fallback (default) when key is missing" do
      transformer = described_class.new :root
      expect(transformer.call({})).to be_success(root: Pathname.pwd)
    end

    it "answers expanded fallback (default) when value is missing" do
      transformer = described_class.new :root
      expect(transformer.call({root: nil})).to be_success(root: Pathname.pwd)
    end

    it "answers expanded fallback (custom) when key is missing" do
      transformer = described_class.new :root, fallback: "demo"
      expect(transformer.call({})).to be_success(root: Bundler.root.join("demo"))
    end
  end
end
