require 'github_scrumboard'
describe GithubScrumboard::UserStory do
let (:body_with_acceptance_criteria) do
body <<-EOS
As somebody
I want...

~Acceptance Criteria
* at least something should be possible
EOS
body
end

  context ".new(issue)" do
    context "extracts details from the comments that are associated with an issue" do
      let (:issue) {{:title => "A Neat Title", :body => "As a user\nI want...", :number => 1}}
      subject {GithubScrumboard::UserStory.new(issue)}

      it "but only the text that is marked up" do
        subject.details.should =~ /Details:.* this is a hint/
      end

      it "if they range over many comments, they are tied together" do
        subject.details.should =~ /Details:.* this is a hint.*this is an implementation detail/
      end

    end

    context "extracts details from the body text of an issue" do
      let (:issue) {{ :title => "A Neat Title", :body => body_with_acceptance_criteria, :number => 2 }}
      subject {GithubScrumboard::UserStory.new(issue)}

      it "e.g. acceptance criteria" do
        subject.details.should =~ /Acceptance Criteria:.*at least something should be possible/
      end

      it "that won't go into the main text of a user story" do
        subject.text.should_not =~ /Acceptance Criteria:.*at least something should be possible/
      end
    end

  end

end
