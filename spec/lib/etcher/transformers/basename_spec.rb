# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Transformers::Basename do
  subject(:transformer) { described_class.new :project_name }

  describe "#initialize" do
    it "is frozen" do
      expect(transformer.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers name when key exists" do
      expect(transformer.call({project_name: "test"})).to be_success(project_name: "test")
    end

    it "answers fallback (default) when key is missing" do
      transformer = described_class.new :project_name
      expect(transformer.call({})).to be_success(project_name: Pathname.pwd.basename.to_s)
    end

    it "answers fallback (custom) when key is missing" do
      transformer = described_class.new :project_name, fallback: "demo"
      expect(transformer.call({})).to be_success(project_name: "demo")
    end
  end
end
