require 'prawn'
require 'github_scrumboard/pdf/story_presenter'
module GithubScrumboard
  module Pdf
    class Exporter

      def self.pagination(index, grid, backside=false)
        i = (index / grid.rows) % grid.columns
        unless backside
          j = index % grid.columns
          return [i, j]
        else
          j = ( -1 -index) % grid.columns
          return [i, j]
        end
      end

      def self.print_cutting_lines(grid)
        y = bounds.top
        x = bounds.left
        w = bounds.width/grid.columns
        h = bounds.height/grid.rows

        dash(5, :space => 2)
        (grid.columns-1).times.each do
          x += w
          vertical_line 0, bounds.height, :at => x
        end

        (grid.rows-1).times.each do
          y += h
          horizontal_line 0, bounds.width, :at => y
        end
        undash
      end

      def create_document(stories)
        pdf = Prawn::Document.generate(Settings.output.filename, :page_layout => Settings.page.layout, :size => Settings.page['size']) do |pdf|
          pdf.font Settings.output.font
          pdf.define_grid(:rows => Settings.grid.rows, :columns => Settings.grid.columns, :gutter => Settings.grid.gutter)
          next_page = false
          stories.each_slice(Settings.grid.rows * Settings.grid.columns).to_a.each_with_index do |stories_fraction, index|
            pdf.start_new_page if next_page
            # FRONTSIDE
            stories_fraction.each_with_index do |story, index|
              i,j = Exporter::pagination(index, Settings.grid)
              pdf.grid(i,j).bounding_box do
                pdf.instance_exec(&Pdf::StoryPresenter.frontside(story))
              end
            end
            # BACKSIDE
            if Settings.output.backside
              pdf.start_new_page
              stories_fraction.each_with_index do |story, index|
                i,j = Exporter::pagination(index, Settings.grid, backside=true)
                pdf.grid(i,j).bounding_box do
                  pdf.instance_exec(&Pdf::StoryPresenter.backside(story))
                end
              end
            end
            next_page = true
          end
        end
      end
    end


  end
end
