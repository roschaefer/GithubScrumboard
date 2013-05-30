require 'octokit'
module GithubScrumboard
  class GithubClient

    def client
      @client ||= Octokit::Client.new(:login => Settings.github.login, :password => Settings.github.password)
    end

    def get_user_stories
      issues = []
      if ([:all, :todo].include?(Settings.stories.state))
        issues.push *fetch_issues("open")
      end
      if ([:all, :done].include?(Settings.stories.state))
        issues.push *fetch_issues("closed")
      end

      stories = issues.collect do |issue|
        UserStory.new(issue)
      end
    end

    def fetch_issues(state)
      issues = []
      page = 0
      begin
        page = page +1
        temp_issues = client.list_issues(Settings.github.project, :state => state, :page => page)
        unless Settings.issues.filter.empty?
          temp_issues.select! {|i| i['labels'].to_s =~ /#{Settings.issues.filter}/}
        end
        issues.push(*temp_issues)
      end while not temp_issues.empty?
      return issues
    end


  end
end
