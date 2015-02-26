module GithubScrumboard
  class UserStory

    attr_accessor :id, :title, :estimation, :priority, :text, :details, :state

    def initialize(issue)
      self.id = issue['number'].to_s
      self.title = issue['title'].to_s
      self.state = ((issue['state'] == "closed") && :done) || :todo
      self.priority = extract_priority(issue['labels'])
      self.estimation = extract_estimation(issue['labels'])
      self.text = without_details(issue['body'].to_s)
      self.details = extract_details(issue['body'].to_s)
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

    def extract_details(body)
      if body =~ self.class.details_regex
        s = body.scan(self.class.details_regex)
        s[0][0]
      else
          ""
      end
    end

    def without_details(body)
      body.gsub(self.class.details_regex,'')
    end

    def self.details_regex
      /^#{Settings.issues.prefix.details}(.*?)(?:^\s*$|\z)/m
    end
  end

end
