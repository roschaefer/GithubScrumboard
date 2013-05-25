require 'octokit'
module GithubScrumboard
  class GithubClient
    def get_user_stories
      client = Octokit::Client.new(:login => Settings.github.login, :password => Settings.github.password)
      issues = []
      page = 0
      begin
        page = page +1
        temp_issues = client.list_issues(Settings.github.project, :state => "open", :page => page)
        unless Settings.issues.filter.empty?
          temp_issues.select! {|i| i['labels'].to_s =~ /#{Settings.issues.filter}/}
        end
        issues.push(*temp_issues)
      end while not temp_issues.empty?

      stories = issues.collect do |issue|
        UserStory.new(issue)
      end
    end
  end
end
