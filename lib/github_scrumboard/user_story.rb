module GithubScrumboard
  class UserStory

    attr_accessor :id, :title, :estimation, :priority, :text

    def initialize(issue)
      self.id = issue['number'].to_s
      self.title = issue['title'].to_s
      self.priority = extract_priority(issue['labels'])
      self.estimation = extract_estimation(issue['labels'])
      self.text = issue['body'].to_s
    end

    def extract_estimation(labels)
      self.extract(labels, /#{GithubScrumboard::Settings.issues.prefix.estimation}(\d+)/)
    end

    def extract_priority(labels)
      self.extract(labels, /#{GithubScrumboard::Settings.issues.prefix.priority}(\d+)/)
    end

    def extract(labels, regex)
      labels.each do |l|
        if l.name =~ regex
          i = l.name.scan(regex)[0][0]
          return i.to_i
        end
      end
      nil
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
            text_box "##{story.id} #{story.title}", :at => [bounds.left, bounds.top], :width => split_width, :height => height, :align => :left
            text_box story.priority_and_estimation, :at => [split_width, bounds.top], :width => (bounds.width - split_width), :height => height, :align => :right
          end
          stroke_horizontal_rule
        end
      end
    end

    def priority_and_estimation
      p = self.priority.nil? ? nil : "Priority: #{self.priority}"
      e = self.estimation.nil? ? nil : "Size: #{self.estimation}"
      [p,e].compact.join("\n")
    end

    def self.backside(story)
      Proc.new do
        font_size(25) { text story.id}
      end
    end
  end

end
