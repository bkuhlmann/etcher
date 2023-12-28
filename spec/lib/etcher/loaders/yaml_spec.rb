# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::YAML do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:loader) { described_class.new path, logger: }

  let(:path) { temp_dir.join "test.yml" }

  include_context "with application dependencies"
  include_context "with temporary directory"

  describe "#call" do
    it "answers hash when valid" do
      path.write "name: test"
      expect(loader.call).to eq(Success("name" => "test"))
    end

    it "answers empty hash when empty" do
      path.touch
      expect(loader.call).to eq(Success({}))
    end

    it "answers empty hash with no keys" do
      path.write "Curabitur eleifend wisi iaculis ipsum."
      expect(loader.call).to eq(Success({}))
    end

    it "answers empty hash with symbol keys" do
      path.write ":name: test"
      expect(loader.call).to eq(Success({}))
    end

    it "logs nil path" do
      loader = described_class.new(nil, logger:)
      loader.call

      expect(logger.reread).to match(/🔎.+Invalid path: "". Using fallback./)
    end

    it "logs invalid path" do
      loader = described_class.new("bogus.yml", logger:)
      loader.call

      expect(logger.reread).to match(/🔎.+Invalid path: "bogus.yml". Using fallback./)
    end

    it "logs invalid content" do
      path.write "Curabitur eleifend"
      loader.call

      expect(logger.reread).to include(%(Invalid content: "Curabitur eleifend". Using fallback.))
    end
  end
end
