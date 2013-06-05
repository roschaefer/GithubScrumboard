module GithubScrumboard
  module Csv
    class StoryPresenter
      attr_accessor :story

      def self.headers
        [:id,:estimation, :priority, :title, :text, :details]
      end

      def self.csv_headers
        self.headers.map {|h| h.to_s.capitalize}
      end

      def initialize(story)
        self.story = story
      end

      def to_csv
        self.class.headers.map do |h|
          story.send(h)
        end
      end

    end
  end
end
