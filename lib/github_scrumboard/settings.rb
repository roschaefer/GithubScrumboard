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

  end
end
