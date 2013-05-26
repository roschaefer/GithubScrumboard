require 'prawn'
require 'github_scrumboard/pdf/story_presenter'
module GithubScrumboard
  module Pdf
    class Exporter

      def pagination(index, grid, backside=false)
        i = (index / grid.rows) % grid.columns
        unless backside
          j = index % grid.columns
          return [i, j]
        else
          j = ( -1 -index) % grid.columns
          return [i, j]
        end
      end

      def export(stories, filename)
        pdf = self.create_document(stories)
        pdf.render_file filename
      end

      def create_document(stories)
        pdf = Prawn::Document.new(:page_layout => Settings.page.layout, :size => Settings.page['size'], :margin => [0,0,0,0])
        stories = stories.collect {|story| Pdf::StoryPresenter.new(story, pdf)}
        pdf.font Settings.output.font
        pdf.define_grid(:rows => Settings.grid.rows, :columns => Settings.grid.columns, :gutter => 0)
        next_page = false
        stories.each_slice(Settings.grid.rows * Settings.grid.columns).to_a.each_with_index do |stories_fraction, index|
          pdf.start_new_page if next_page
          # FRONTSIDE
          stories_fraction.each_with_index do |story, index|
            i,j = self.pagination(index, Settings.grid)
            pdf.grid(i,j).bounding_box do
              story.frontside
            end
          end
          # BACKSIDE
          if Settings.output.backside
            pdf.start_new_page
            stories_fraction.each_with_index do |story, index|
              i,j = self.pagination(index, Settings.grid, backside=true)
              pdf.grid(i,j).bounding_box do
                story.backside
              end
            end
          end
          next_page = true
        end
        pdf
    end
  end


  end
end
