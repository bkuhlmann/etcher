# frozen_string_literal: true

require "dry/monads"

module Etcher
  # A simple passthrough contract.
  Contract = lambda do |result|
    def result.to_monad = Dry::Monads::Success self unless result.respond_to? :to_monad
    result
  end
end
