require 'github_scrumboard'
describe GithubScrumboard::Configuration do

  context "#load" do
    it "should perform a deep merge" do
      hash1 = {:a  => {:b => {:c  => 1}}}
      hash2 = {:a => {:b => {:d => 2}}, :e => 3}
      subject.load(hash1)
      subject.load(hash2)

      subject.a.b.c.should eq 1
      subject.a.b.d.should eq 2
      subject.e.should eq 3
    end
  end

  context "#load_defaults" do
    before(:all) {GithubScrumboard::Configuration.load_defaults}
    context "grid" do
      [:columns, :rows, :gutter].each do |key|
        subject {GithubScrumboard::Configuration.grid.send(key)}
        it {should_not be_nil}
        it {should be_kind_of(Integer)}
      end
    end

    context "page layout" do
      subject {GithubScrumboard::Configuration.page.layout}
      it {should_not be_nil}
    end

    context "page size" do
      subject {GithubScrumboard::Configuration.page['size']}
      it {should_not be_nil}
      it {should be_kind_of(String)}
    end

    context "output filename" do
      subject {GithubScrumboard::Configuration.output.filename}
      it {should_not be_nil}
      it {should be_kind_of(String)}
    end

  end
end
