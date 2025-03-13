# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Loaders::YAML do
  using Refinements::Pathname

  subject(:loader) { described_class.new path, logger: }

  let(:path) { temp_dir.join "test.yml" }

  include_context "with application dependencies"
  include_context "with temporary directory"

  describe "#initialize" do
    it "is frozen" do
      expect(loader.frozen?).to be(true)
    end
  end

  describe "#call" do
    it "answers hash when valid" do
      path.write "name: test"
      expect(loader.call).to be_success("name" => "test")
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

    it "fails with nil content" do
      path.touch

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: "File is empty: #{path.to_s.inspect}."
      )
    end

    it "fails with empty content" do
      path.write "\n"

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: "File is empty: #{path.to_s.inspect}."
      )
    end

    it "fails with invalid content" do
      path.write "Danger!"

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: %(Invalid content: "Danger!". Path: #{path.to_s.inspect}.)
      )
    end

    it "fails with invalid alias" do
      path.write <<~CONTENT
        &danger
        - *danger
      CONTENT

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: "Aliases are disabled, please remove. Path: #{path.to_s.inspect}."
      )
    end

    it "fails with invalid type" do
      path.write ":name: test"

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: "Invalid type, tried to load unspecified class: Symbol. " \
                 "Path: #{path.to_s.inspect}."
      )
    end

    it "fails with invalid syntax" do
      path.write "danger: %<value>s is invalid"

      expect(loader.call).to be_failure(
        step: :load,
        constant: described_class,
        payload: "Invalid syntax, found character that cannot start any token while scanning " \
                 "for the next token at line 1 column 9. Path: #{path.to_s.inspect}."
      )
    end
  end
end
