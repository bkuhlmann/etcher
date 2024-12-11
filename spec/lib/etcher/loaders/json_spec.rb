# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::JSON do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:loader) { described_class.new path, logger: }

  let(:path) { temp_dir.join "test.json" }

  include_context "with application dependencies"
  include_context "with temporary directory"

  describe "#initialize" do
    it "is frozen" do
      expect(loader.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers hash when valid" do
      path.write({name: "test"}.to_json)
      expect(loader.call).to eq(Success("name" => "test"))
    end

    it "logs nil path" do
      loader = described_class.new(nil, logger:)
      loader.call

      expect(logger.reread).to match(/🔎.+Invalid path: "". Using fallback./)
    end

    it "logs invalid path" do
      loader = described_class.new("bogus.json", logger:)
      loader.call

      expect(logger.reread).to match(/🔎.+Invalid path: "bogus.json". Using fallback./)
    end

    it "fails with nil content" do
      path.touch

      expect(loader.call).to eq(
        Failure(
          step: :load,
          constant: described_class,
          payload: "File is empty: #{path.to_s.inspect}."
        )
      )
    end

    it "fails with empty content" do
      path.write "\n"

      expect(loader.call).to eq(
        Failure(
          step: :load,
          constant: described_class,
          payload: "File is empty: #{path.to_s.inspect}."
        )
      )
    end

    it "fails with invalid content" do
      path.write "Danger!"

      expect(loader.call).to eq(
        Failure(
          step: :load,
          constant: described_class,
          payload: %(Invalid content: "Danger!". Path: #{path.to_s.inspect}.)
        )
      )
    end
  end
end
