# frozen_string_literal: true

require "dry/monads"

# Finds internal constant if moniker matches, otherwise answers a failure.
module Etcher
  include Dry::Monads[:result]

  Finder = lambda do |namespace, moniker|
    Etcher.const_get(namespace)
          .constants
          .find { |constant| constant.downcase == moniker }
          .then do |constant|
            return Dry::Monads::Success Etcher.const_get("#{namespace}::#{constant}") if constant

            Dry::Monads::Failure "Unable to select #{moniker.inspect} within #{namespace.downcase}."
          end
  rescue NameError
    Dry::Monads::Failure "Invalid namespace: #{namespace.inspect}."
  end
end
