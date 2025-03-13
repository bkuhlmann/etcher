# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Transformers::Format do
  subject(:transformer) { described_class.new :uri }

  describe "#initialize" do
    it "is frozen" do
      expect(transformer.frozen?).to be(true)
    end
  end

  describe "#call" do
    let :attributes do
      {
        organization: "acme",
        project: "test",
        uri: "https://test.io/%<organization>s/%<project>s/issues"
      }
    end

    it "answers formatted string when key exists" do
      expect(transformer.call(attributes)).to be_success(
        organization: "acme",
        project: "test",
        uri: "https://test.io/acme/test/issues"
      )
    end

    it "answers failure when specifiers are missing" do
      attributes.delete :project

      expect(transformer.call(attributes)).to be_failure(
        step: :transform,
        constant: described_class,
        payload: %(Unable to transform :uri, missing specifier: "<project>".)
      )
    end

    it "answers original attributes when there is nothing to format" do
      attributes[:uri] = "https://test.io"
      expect(transformer.call(attributes)).to be_success(attributes)
    end

    it "answers original attributes when key is nil" do
      attributes[:uri] = nil
      expect(transformer.call(attributes)).to be_success(attributes)
    end

    it "answers original attributes when key doesn't exist" do
      expect(transformer.call({})).to be_success({})
    end

    context "with retainers" do
      subject(:transformer) { described_class.new :text, :one, :two }

      it "formats text with retainers preserved" do
        expect(transformer.call({text: "Test: %<one>s, %<two>s"})).to be_success(
          text: "Test: %<one>s, %<two>s"
        )
      end

      it "formats text with retainers ignored" do
        expect(transformer.call({text: "Test"})).to be_success(text: "Test")
      end
    end

    context "with mappings" do
      subject(:transformer) { described_class.new :text, tag_a: "A", tag_b: "B" }

      let :attributes do
        {
          text: "%<prefix>s: %<message>s [%<tag_a>s %<tag_b>s]",
          prefix: "Test",
          message: "A test."
        }
      end

      it "formats text" do
        expect(transformer.call(attributes)).to be_success(
          text: "Test: A test. [A B]",
          prefix: "Test",
          message: "A test."
        )
      end

      it "formats text with mappings ignored" do
        attributes[:text] = "%<prefix>s: %<message>s"

        expect(transformer.call(attributes)).to be_success(
          text: "Test: A test.",
          prefix: "Test",
          message: "A test."
        )
      end
    end
  end
end
