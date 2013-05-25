require "github_scrumboard/version"
require 'github_scrumboard/settings'
require 'github_scrumboard/user_story'
require 'github_scrumboard/pdf_exporter'
require 'github_scrumboard/github_client'

require 'highline/import'
require 'pry'
require 'optparse'
module GithubScrumboard
  class Cli

  OptionParser.new do |o|
    o.on('-p', "--print FILENAME", String, "print to file") do |f|
      GithubScrumboard::Settings.output['filename'] = f
    end
    o.parse!
  end


    def run!
      Settings.try_file "#{Dir.home}/.github_scrumboard.yml"
      Settings.try_file "#{Dir.home}/github_scrumboard.yml"
      Settings.try_file "#{Dir.pwd}/github_scrumboard.yml"

      # some settings are mandatory, dear user
      Settings['github'] ||= {}
      ['login', 'project', 'password'].each do |c|
        Settings.github[c] ||= ask("Enter #{c}: ") { |q| q.echo = false if c == 'password' }
      end

      puts "Getting issues from Github..."
      gh_client = GithubClient.new
      stories = gh_client.get_user_stories

      puts "Generating output"
      exporter = PdfExporter.new
      exporter.create_document(stories)

      puts "Done!"

    end
  end


end
