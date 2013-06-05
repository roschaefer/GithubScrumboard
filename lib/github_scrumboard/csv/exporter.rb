require 'csv'
require 'github_scrumboard/csv/story_presenter'
module GithubScrumboard
  module Csv
    class Exporter
      def export(stories, filename)
        CSV.open(filename, 'wb') do |csv|
          csv << Csv::StoryPresenter.csv_headers
          stories.each do |story|
            presenter = Csv::StoryPresenter.new(story)
            csv << presenter.to_csv
          end
        end
      end
    end
  end
end
