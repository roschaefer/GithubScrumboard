require "github_scrumboard/version"
require 'github_scrumboard/settings'
require 'github_scrumboard/user_story'
require 'github_scrumboard/pdf/exporter'
require 'github_scrumboard/csv/exporter'
require 'github_scrumboard/github_client'
require 'logger'
require "thor"

require 'highline/import'
require 'pry'
module GithubScrumboard
  class Cli < Thor

    desc "run!", "generate a user stories pdf"
    method_option :output, :type => :string, :aliases => ['-o','--out'], :desc => "The output filename"
    def run!
      Settings['logger_level'] = Settings.logger_level.to_sym
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

      Settings.output['filename'] = options[:output] if options[:output]

      Settings.normalize!

      unless Settings.errors.empty?
        logger.error("Invalid configuration:")
        Settings.errors.each do |e|
          logger.error(e)
        end
        exit 1
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

      case Settings.file_extension
      when :pdf
        exporter = Pdf::Exporter.new
        exporter.export(stories, Settings.output.filename)
      when :csv
        exporter = Csv::Exporter.new
        exporter.export(stories, Settings.output.filename)
      end

      logger.info( "Done!")

    end

    default_task :run!
  end


end
