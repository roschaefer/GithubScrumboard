require 'github_scrumboard'
describe GithubScrumboard::Settings do

  context "#try_file" do
    #it "should perform a deep merge" do
      #yaml1 = <<-EOS
#a:
  #b:
    #c: 1
      #EOS
      #yaml2 = <<-EOS
#a:
  #b:
    #d: 2
#e: 3
      #EOS
      #File.should_receive(:open).with("file1", 'r').and_yield(yaml1)
      #File.should_receive(:open).with("file2", 'r').and_yield(yaml2)
      #GithubScrumboard::Settings.try_file("file1")
      #GithubScrumboard::Settings.try_file("file2")

      #subject.a.b.c.should eq 1
      #subject.a.b.d.should eq 2
      #subject.e.should eq 3
    #end
  end

    context "grid" do
      [:columns, :rows, :margin].each do |key|
        subject {GithubScrumboard::Settings.grid.send(key)}
        it {should_not be_nil}
        it {should be_kind_of(Integer)}
      end
    end

    context "page layout" do
      subject {GithubScrumboard::Settings.page.layout}
      it {should_not be_nil}
    end

    context "page size" do
      subject {GithubScrumboard::Settings.page['size']}
      it {should_not be_nil}
      it {should be_kind_of(String)}
    end

    context "output filename" do
      subject {GithubScrumboard::Settings.output.filename}
      it {should_not be_nil}
      it {should be_kind_of(String)}
    end

end
