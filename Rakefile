require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

namespace :cucumber do
  Cucumber::Rake::Task.new(:wip, "Run pending features") do |t|
    t.cucumber_opts = "features --format pretty --tags @wip --wip"
  end

  Cucumber::Rake::Task.new(:ok, "Run implemented features") do |t|
    t.cucumber_opts = "features --format pretty --tags ~@wip"
  end
end

desc "Run all cucumber features"
task :cucumber => ["cucumber:ok", "cucumber:wip"]
