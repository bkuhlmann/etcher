# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "etcher"
  spec.version = "0.0.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/etcher"
  spec.summary = "A configuration loader, transformer, and validator."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/etcher/issues",
    "changelog_uri" => "https://alchemists.io/projects/etcher/versions",
    "documentation_uri" => "https://alchemists.io/projects/etcher",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Etcher",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/etcher"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.2"
  spec.add_dependency "refinements", "~> 10.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
