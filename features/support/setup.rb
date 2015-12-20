require 'github_scrumboard'
require 'aruba/api'
require 'pry'
require 'pdf/toolkit'
require 'vcr'
require 'github_scrumboard'

module Helpers
  def github_scrumboard_executable(args)
    cmd = ["github_scrumboard", args].join(" ")
    @command = run_simple(cmd, :fail_on_error => false)
  end
end

VCR.config do |c|
  c.stub_with :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { :record => :none }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end

class VcrFriendlyMain
  def initialize(argv, stdin, stdout, stderr, kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    cli = GithubScrumboard::Cli.new
    cli.parse(@argv)
    cli.run!
  end
end


World(Helpers)
World(Aruba::Api)
