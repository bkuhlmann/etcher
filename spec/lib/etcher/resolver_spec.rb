# frozen_string_literal: true

require "spec_helper"

RSpec.describe Etcher::Resolver do
  subject(:resolver) { described_class.new registry, logger: }

  let(:registry) { Etcher::Registry.new }
  let(:logger) { instance_spy Cogger::Hub }

  describe "#initialize" do
    it "is frozen" do
      expect(resolver.frozen?).to be(true)
    end
  end

  describe "#call" do
    let :contract do
      Dry::Schema.Params do
        required(:name).filled :string
        required(:label).filled :string
        required(:bag).filled(:array).each(:hash) do
          required(:token).filled :string
          required(:items).filled(:array).each(:hash) { required(:text).filled :string }
        end
      end
    end

    it "answers configuration with success" do
      expect(resolver.call).to eq({})
    end

    context "with load failure" do
      let :registry do
        Etcher::Registry[
          loaders: [proc { Failure step: :load, constant: "Test", payload: "Danger!" }]
        ]
      end

      it "logs and aborts" do
        resolver.call
        expect(logger).to have_received(:abort).with("Load failure (Test). Danger!")
      end
    end

    context "with transform failure" do
      let :registry do
        Etcher::Registry[
          transformers: [proc { Failure step: :transform, constant: "Test", payload: "Danger!" }]
        ]
      end

      it "logs and aborts" do
        resolver.call
        expect(logger).to have_received(:abort).with("Transform failure (Test). Danger!")
      end
    end

    context "with contract nested results failure" do
      let(:registry) { Etcher::Registry[contract:] }

      it "logs and aborts" do
        resolver.call bag: [{}]

        expect(logger).to have_received(:abort).with(
          "Validate failure (Etcher::Builder). Unable to load configuration:\n  " \
          "- name is missing\n  " \
          "- label is missing\n  " \
          "- bag.0.token is missing\n  " \
          "- bag.0.items is missing\n"
        )
      end
    end

    context "with model failure" do
      let(:registry) { Etcher::Registry[contract:, model: Data.define] }

      it "logs and aborts" do
        resolver.call name: "test", label: "Test", bag: [{token: "one", items: [{text: "test"}]}]

        expect(logger).to have_received(:abort).with(
          "Model failure (Etcher::Builder). Unknown keywords: :name, :label, :bag."
        )
      end
    end

    context "with string failure" do
      let(:registry) { Etcher::Registry[transformers: [proc { Failure "Danger!" }]] }

      it "logs and aborts" do
        resolver.call
        expect(logger).to have_received(:abort).with("Danger!")
      end
    end

    context "with unknown failure" do
      let(:registry) { Etcher::Registry[transformers: [proc { Failure :danger }]] }

      it "logs and aborts" do
        resolver.call
        expect(logger).to have_received(:abort).with("Unable to parse failure.")
      end
    end
  end
end
