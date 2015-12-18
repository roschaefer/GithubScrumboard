require "github_scrumboard/version"
require 'github_scrumboard/settings'
require 'github_scrumboard/user_story'
require 'github_scrumboard/pdf/exporter'
require 'github_scrumboard/github_client'
require 'logger'
require 'highline/import'
require 'pry'
require 'optparse'
require 'ostruct'

module GithubScrumboard
  class Cli
    attr_reader :options

    def parse(args)
      options = OpenStruct.new
      options.verbose = false

      parser = OptionParser.new do |opts|
        opts.banner = "Github Scrumboard is a tool to create pdfs from your github issues.\nAfter creating the pdf, you can print the issues, cut them out and put them on a physical scrum board."
        opts.separator ""
        opts.on_tail("-h", "--help", "Show this message") do |v|
          puts opts
          puts
          puts "Further information:"
          puts "  https://github.com/roschaefer/github_scrumboard"
          exit
        end

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options.verbose = v
        end

        opts.on_tail("--version", "Show version") do
          puts GithubScrumboard::VERSION
          exit
        end

      end

      parser.parse!(args)
      @options = options
    end

    def symbolize_logger_settings
      Settings['logger_level'] = Settings.logger_level.to_sym
    end

    def run!
      self.symbolize_logger_settings
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

      Settings.normalize!
      unless Settings.errors.empty?
        logger.error("Invalid configuration:")
        Settings.errors.each do |e|
          logger.error(e)
        end
        exit 1
      end

      if options.verbose
        puts "Configuration so far:"
        puts Settings.to_hash.to_yaml
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
