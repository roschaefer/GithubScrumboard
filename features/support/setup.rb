require 'github_scrumboard'
require 'aruba/api'
require 'pry'

module Helpers
  def github_scrumboard_executable(args)
    cmd = ["github_scrumboard", args].join(" ")
    @command = run_simple(cmd, :fail_on_error => false)
  end
end

World(Helpers)
World(Aruba::Api)
