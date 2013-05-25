# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_scrumboard/version'

Gem::Specification.new do |spec|
  spec.name          = "github_scrumboard"
  spec.version       = GithubScrumboard::VERSION
  spec.authors       = ["Robert Schaefer"]
  spec.email         = ["rs@oxon.ch"]
  spec.description   = %q{Don't bother to use any online tools for agile development. Regard your github issues as user stories and print them out for use on a physical scrumboard.}
  spec.summary       = %q{Exports your github issues as pdf with a fixed layout}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'prawn', "~> 0.12.0"
  spec.add_dependency "octokit", "~> 1.24.0"
  spec.add_dependency "highline", "~> 1.6.19"
  spec.add_dependency "active_support", "~> 3.0.0"
  spec.add_dependency "mash", "~> 0.1.1"

  spec.add_development_dependency "pry", "~> 0.9.12.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
