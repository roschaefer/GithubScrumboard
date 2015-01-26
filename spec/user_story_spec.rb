require 'github_scrumboard'
describe GithubScrumboard::UserStory do
  let (:body) {
'''
As somebody
I want...

= Acceptance Criteria:
* at least something should be possible
'''
}

  context ".new(issue)" do
    context "extracts details, that are marked by a sign" do
      before(:each) do
        GithubScrumboard::UserStory.any_instance.stub(:extract).and_return(1)
        GithubScrumboard::Settings.issues.prefix.stub(:details).and_return('=')
      end

      context "from the comment section of an issue" do
          let (:issue) {{'title' => "A Neat Title", 'body' => "As a user\nI want...", 'number' => 1}}
          subject {GithubScrumboard::UserStory.new(issue)}

          it "but only the text that is marked up" do
            skip do
              subject.details.should =~ /Details:.* this is a hint/
            end
          end

          it "multiple detail descriptions are tied together" do
            skip do
              subject.details.should =~ /Details:.* this is a hint.*this is an implementation detail/
            end
          end

      end

      context "from the body of an issue" do
        let (:issue) {{ 'title' => 'A Neat Title', 'body' => body, 'number' => 2}}
        subject {GithubScrumboard::UserStory.new(issue)}

        it "e.g. acceptance criteria" do
          subject.text.should =~ /As somebody/
          subject.details.should =~ /Acceptance Criteria:.*at least something should be possible/m
        end

        it "that won't go into the main text of a user story" do
          subject.text.should =~ /As somebody/
          subject.text.should_not =~ /Acceptance Criteria:.*at least something should be possible/m
        end

        it 'and won\'t crash, if there is no details section at all' do
          issue['body']= "Something, that is not a details section\n\nDefinitely not"
          story = GithubScrumboard::UserStory.new(issue)
          story.details.should be_empty
          story.text.should eq issue['body']
        end

        context "the ending is" do
          it "an empty line" do
            issue['body'] << "\n \nfoobar"
            story = GithubScrumboard::UserStory.new(issue)
            story.details.should include("Acceptance Criteria:")
            story.details.should include("something")
            story.details.should_not include("foobar")
            story.text.should include("foobar")
          end

          it "the end of the text" do
            issue['body'] << "foobar"
            story = GithubScrumboard::UserStory.new(issue)
            story.details.should include("foobar")
            story.text.should_not include("foobar")
          end
        end

      end



    end

  end
end
