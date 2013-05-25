require 'settingslogic'
require 'active_support/core_ext/hash/deep_merge'
module GithubScrumboard
  class Settings < Settingslogic
    source "#{File.dirname(__FILE__)}/defaults.yml"

    def self.try_file(filename)
      print filename
      if File.exist?(filename)
        instance.deep_merge!(Settings.new(filename))
      end
    end

  end
end
