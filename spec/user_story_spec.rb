require 'github_scrumboard'
describe GithubScrumboard::UserStory do
  let (:body) {
    '''
As somebody
I want...

~Acceptance Criteria
* at least something should be possible
    '''
  }

  context ".new(issue)" do
    context "extracts details, that are marked by a sign" do
      before(:each) do
        GithubScrumboard::UserStory.any_instance.stub(:extract).and_return(1)
      end

      context "from the comment section of an issue" do
        let (:issue) {{'title' => "A Neat Title", 'body' => "As a user\nI want...", 'number' => 1}}
        subject {GithubScrumboard::UserStory.new(issue)}

        it "but only the text that is marked up" do
          subject.details.should =~ /Details:.* this is a hint/
        end

        it "multiple detail descriptions are tied together" do
          subject.details.should =~ /Details:.* this is a hint.*this is an implementation detail/
        end

      end

      context "from the body of an issue" do
        let (:issue) {{ 'title' => 'A Neat Title', 'body' => body, 'number' => 2}}
        subject {GithubScrumboard::UserStory.new(issue)}

        it "e.g. acceptance criteria" do
          subject.details.should =~ /Acceptance Criteria:.*at least something should be possible/
        end

        it "that won't go into the main text of a user story" do
          subject.text.should_not =~ /Acceptance Criteria:.*at least something should be possible/
        end

        context "the ending is" do
          it "either an empty line" do
            issue.body << "\n\nfoobar"
            story = UserStory.new(issue)
            story.details.should_not include("foobar")
          end

          it "or the end of the text" do
            issue.body << "foobar"
            story = UserStory.new(issue)
            story.details.should include("foobar")
          end
        end

      end



    end

  end
end