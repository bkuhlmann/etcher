# frozen_string_literal: true

require "dry/monads"

module Etcher
  # A simple passthrough contract.
  Contract = lambda do |content|
    def content.to_monad = Dry::Monads::Success self unless content.respond_to? :to_monad
    content
  end
end
