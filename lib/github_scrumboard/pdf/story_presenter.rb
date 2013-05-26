module GithubScrumboard
  module Pdf
    class StoryPresenter

      def self.frontside(story)
        Proc.new do
          instance_exec(&Pdf::StoryPresenter.header(story))
          instance_exec(&Pdf::StoryPresenter.body(story))
        end
      end

      def self.backside(story)
        Proc.new do
          font_size(25) {text Pdf::StoryPresenter.backside_text}
        end
      end

      def self.body(story)
        Proc.new do
          bounding_box [0, cursor], :width  => bounds.width do
            text_box story.text, :at => [bounds.left, bounds.top], :width => bounds.width
          end
        end
      end

      def self.header(story, height = 30)
        Proc.new do
          bounding_box [bounds.left, bounds.top], :width  => bounds.width, :height => height*1.25 do
            bounding_box [bounds.left, bounds.top], :width  => bounds.width, :height => height do
              split_width = 0.80 * bounds.width
              text_box Pdf::StoryPresenter.id_and_title(story), :at => [bounds.left, bounds.top], :width => split_width, :height => height, :align => :left
              text_box Pdf::StoryPresenter.priority_and_estimation(story), :at => [split_width, bounds.top], :width => (bounds.width - split_width), :height => height, :align => :right
            end
            stroke_horizontal_rule
          end
        end
      end

      def self.priority_and_estimation(story)
        p = story.priority.nil? ? nil : "Priority: #{story.priority}"
        e = story.estimation.nil? ? nil : "Size: #{story.estimation}"
        [p,e].compact.join("\n")
      end

      def self.id_and_title(story)
        "##{story.id} #{story.title}"
      end

      def self.backside_text(story)
         story.id
      end

    end
  end
end
