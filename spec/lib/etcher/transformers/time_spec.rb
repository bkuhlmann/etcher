# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Transformers::Time do
  subject(:transformer) { described_class.new :loaded_at, fallback: at }

  let(:at) { Time.now.utc }

  describe "#initialize" do
    it "is frozen" do
      expect(transformer.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers original attributes when key and value are present" do
      expect(transformer.call({loaded_at: at})).to be_success(loaded_at: at)
    end

    it "answers fallback when attributes are empty" do
      expect(transformer.call({})).to be_success(loaded_at: at)
    end

    it "answers fallback without attributes or custom time" do
      transformer = described_class.new :loaded_at
      expect(transformer.call({}).success).to match(loaded_at: kind_of(Time))
    end

    it "answers custom key and fallback when attributes are empty" do
      transformer = described_class.new :now, fallback: at
      expect(transformer.call({})).to be_success(now: at)
    end
  end
end
