# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Transformers::Time do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new fallback: at }

  let(:at) { Time.now.utc }

  describe "#call" do
    it "answers original attributes when key and value are present" do
      expect(transformer.call({loaded_at: at})).to eq(Success(loaded_at: at))
    end

    it "answers fallback when attributes are empty" do
      expect(transformer.call({})).to eq(Success(loaded_at: at))
    end

    it "answers fallback without attributes or custom time" do
      transformer = described_class.new
      expect(transformer.call({}).success).to match(loaded_at: kind_of(Time))
    end

    it "answers custom key and fallback when attributes are empty" do
      transformer = described_class.new :now, fallback: at
      expect(transformer.call({})).to eq(Success(now: at))
    end
  end
end
