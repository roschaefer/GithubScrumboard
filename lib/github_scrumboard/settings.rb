require 'settingslogic'
require 'active_support/core_ext/hash/deep_merge'
module GithubScrumboard
  class Settings < Settingslogic
    source "#{File.dirname(__FILE__)}/defaults.yml"

    def self.try_file(filename)
      if File.exist?(filename)
        instance.deep_merge!(Settings.new(filename))
        true
      else
        false
      end
    end

    def self.normalize!
      self.class.page['layout']  = self.class.page.layout.to_sym
      self.class['logger_level'] = self.class.logger_level.to_sym
    end

    def self.errors
      errors = []
      if self.issues.prefix.details.empty?
        errors << "Details prefix pattern is empty!"
      end
      return errors
    end

  end
end
