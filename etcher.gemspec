# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "etcher"
  spec.version = "3.4.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/etcher"
  spec.summary = "A monadic configuration loader, transformer, and validator."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/etcher/issues",
    "changelog_uri" => "https://alchemists.io/projects/etcher/versions",
    "homepage_uri" => "https://alchemists.io/projects/etcher",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Etcher",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/etcher"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 3.4"
  spec.add_dependency "cogger", "~> 1.0"
  spec.add_dependency "core", "~> 2.5"
  spec.add_dependency "dry-monads", "~> 1.9"
  spec.add_dependency "dry-types", "~> 1.7"
  spec.add_dependency "refinements", "~> 13.6"
  spec.add_dependency "versionaire", "~> 14.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
