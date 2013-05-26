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
  end

end
