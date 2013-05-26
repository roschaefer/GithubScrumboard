require 'active_support/core_ext/array/extract_options'
module GithubScrumboard
  module Pdf
    class StoryPresenter
      attr_accessor :story, :pdf

      def initialize(story, pdf)
        self.story = story
        self.pdf = pdf
      end

      def frontside
        if Settings.output.cutting_lines then self.cutting_lines end
        padded_box do
          self.header
          self.body
        end
      end

      def backside
        if Settings.output.cutting_lines then self.cutting_lines end
        padded_box do
          self.pdf.font_size(25) {self.pdf.text backside_text}
        end
      end

      def padded_box(padding = Settings.grid.margin, &block)
        pdf = self.pdf
        pdf.bounding_box [padding, pdf.bounds.height-padding], width: pdf.bounds.width-2*padding, height: pdf.bounds.height-2*padding do
          block.call
        end
      end

      def cutting_lines
        former_color = self.pdf.stroke_color
        self.pdf.stroke_color 0,0,0,30
        self.pdf.dash(5, :space => 10)
        self.pdf.stroke_bounds
        self.pdf.undash
        self.pdf.stroke_color = former_color
      end

      def body
        pdf = self.pdf
        pdf.bounding_box [0, pdf.cursor], :width  => pdf.bounds.width do
          pdf.text_box story.text, :at => [pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width
        end
      end

      def header(height = 30)
        pdf = self.pdf
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width, :height => height*1.25 do
          pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width, :height => height do
            split_width = 0.80 * pdf.bounds.width
            pdf.text_box Pdf::StoryPresenter.id_and_title(story), :at => [pdf.bounds.left, pdf.bounds.top], :width => split_width, :height => height, :align => :left
            pdf.text_box Pdf::StoryPresenter.priority_and_estimation(story), :at => [split_width, pdf.bounds.top], :width => (pdf.bounds.width - split_width), :height => height, :align => :right
          end
          pdf.stroke_horizontal_rule
        end
      end

      def self.priority_and_estimation(story)
        p = story.priority.nil? ? nil : "Priority: #{story.priority}"
        e = story.estimation.nil? ? nil : "Hours: #{story.estimation}"
        [p,e].compact.join("\n")
      end

      def self.id_and_title(story)
        "##{story.id} #{story.title}"
      end

      def backside_text
         self.story.id.to_s
      end

    end
  end
end
