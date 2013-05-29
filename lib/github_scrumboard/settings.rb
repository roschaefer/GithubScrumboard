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
      self.page['layout']  = self.page.layout.to_sym
      self['logger_level'] = self.logger_level.to_sym
      self.issues.prefix['details'] = Regexp.escape(self.issues.prefix.details)
    end

    def self.errors
      errors = []
      if self.issues.prefix.details.nil? ||  self.issues.prefix.details.empty?
        errors << "Details prefix pattern is empty!"
      end
      return errors
    end

  end
end
