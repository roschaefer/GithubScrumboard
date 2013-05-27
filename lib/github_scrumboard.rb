require "github_scrumboard/version"
require 'github_scrumboard/settings'
require 'github_scrumboard/user_story'
require 'github_scrumboard/pdf/exporter'
require 'github_scrumboard/github_client'
require 'logger'

require 'highline/import'
require 'pry'
require 'optparse'
module GithubScrumboard
  class Cli

    def symbolize_certain_settings
      Settings['logger_level'] = Settings.logger_level.to_sym
      Settings.page['layout']  = Settings.page.layout.to_sym
    end

    def run!
      self.symbolize_certain_settings
      logger = Logger.new(STDOUT)
      levels = {:debug => Logger::DEBUG, :info => Logger::INFO, :warn => Logger::WARN, :error => Logger::ERROR, :fatal => Logger::FATAL}
      logger.level = levels[Settings.logger_level]
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity}: #{msg}\n"
      end

      ["#{Dir.home}/.github_scrumboard.yml", "#{Dir.home}/github_scrumboard.yml", "#{Dir.pwd}/github_scrumboard.yml"].each do |filename|
        if Settings.try_file filename
          logger.info("Found configuration file: #{filename}")
        end
      end

      # some settings are mandatory, dear user
      Settings['github'] ||= {}
      ['login', 'project', 'password'].each do |c|
        Settings.github[c] ||= ask("Enter #{c}: ") { |q| q.echo = false if c == 'password' }
      end

      logger.info( "Getting issues from Github...")
      gh_client = GithubClient.new
      stories = gh_client.get_user_stories

      logger.info( "Generating #{Settings.output.filename}")
      exporter = Pdf::Exporter.new
      exporter.export(stories, Settings.output.filename)

      logger.info( "Done!")

    end
  end


end
