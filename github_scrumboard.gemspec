# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_scrumboard/version'

Gem::Specification.new do |spec|
  spec.name          = "github_scrumboard"
  spec.version       = GithubScrumboard::VERSION
  spec.authors       = ["Robert Schaefer"]
  spec.email         = ["robert.schaefer@student.hpi.uni-potsdam.de"]
  spec.description   = %q{Don't use online tools for agile development. Regard your github issues as user stories and print and put them on a physical scrumboard.}
  spec.summary       = %q{Exports your github issues as pdf with a fixed layout}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["github_scrumboard"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'prawn', "~> 1.3.0"
  spec.add_dependency "octokit", "~> 3.7.0"
  spec.add_dependency "highline", "~> 1.6.21"
  spec.add_dependency "settingslogic", "~> 2.0.9"
  spec.add_dependency "activesupport", "~> 4.2.0"

  spec.add_development_dependency "pry", "~> 0.9.12.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
end
