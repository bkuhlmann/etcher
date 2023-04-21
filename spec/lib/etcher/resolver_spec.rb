# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Resolver do
  include Dry::Monads[:result]

  subject(:resolver) { described_class.new registry, logger:, kernel: }

  let(:registry) { Etcher::Registry.new }

  include_context "with application dependencies"

  describe "#call" do
    let :contract do
      Dry::Schema.Params do
        required(:name).filled :string
        required(:label).filled :string
      end
    end

    it "answers configuration with success" do
      expect(resolver.call).to eq({})
    end

    context "with contract failure" do
      let(:registry) { Etcher::Registry[contract:] }

      before { resolver.call }

      it "logs fatal details" do
        expect(logger.reread).to have_color(
          Cogger.color,
          ["🔥 "],
          [
            "Unable to load configuration due to the following issues:\n  - name is " \
            "missing\n  - label is missing\n",
            :bold,
            :white,
            :on_red
          ],
          ["\n"]
        )
      end

      it "aborts" do
        expect(kernel).to have_received(:abort)
      end
    end

    context "with model failure" do
      let(:registry) { Etcher::Registry[contract:, model: Data.define] }

      before { resolver.call name: "test", label: "Test" }

      it "logs fatal details" do
        expect(logger.reread).to have_color(
          Cogger.color,
          ["🔥 "],
          [
            "Build failure: :record. Unknown keywords: :name, :label.",
            :bold,
            :white,
            :on_red
          ],
          ["\n"]
        )
      end

      it "aborts" do
        expect(kernel).to have_received(:abort)
      end
    end

    context "with invalid builder" do
      let(:registry) { Etcher::Registry[transformers: [proc { Failure ["Danger!"] }]] }

      it "fails" do
        expectation = proc { resolver.call }
        expect(&expectation).to raise_error(StandardError, "Unable to parse configuration.")
      end
    end
  end
end
