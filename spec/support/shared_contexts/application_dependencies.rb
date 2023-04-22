# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  let(:logger) { Cogger.new id: :test, io: StringIO.new, level: :debug, formatter: :emoji }
  let(:kernel) { class_spy Kernel }
end
