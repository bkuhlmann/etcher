# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  let(:logger) { Cogger.new id: :etcher, io: StringIO.new, level: :debug }
end
