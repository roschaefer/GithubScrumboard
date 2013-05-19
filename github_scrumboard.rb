require 'prawn'
require 'octokit'
require 'configatron'
require 'highline/import'


begin
  require_relative 'github2scrumboard'
rescue LoadError
  abort "Couldn't find a configuration file!"
end

# DEFAULTS
## LAYOUT
configatron.layout.set_default(:columns, 2)
configatron.layout.set_default(:rows, 2)
configatron.layout.set_default(:gutter, 30)
configatron.layout.set_default(:page, :landscape)

## ISSUE LABELS
configatron.labels.set_default(:priority, 'P')
configatron.labels.set_default(:size, 'H')

## FILTERS
configatron.filter.set_default(:label, 'USERSTORY')

class UserStory
  attr_accessor :id, :title, :size, :priority, :text
  def initialize(issue)
    self.id = issue['number'].to_s
    self.title = issue['title'].to_s
    self.size = fish_for_size(issue['labels'])
    self.priority = fish_for_priority(issue['labels'])
    self.text = issue['body'].to_s
  end

  def fish_for_size(labels)
    fish_for(labels, /#{configatron.labels.size}(\d+)/)
  end

  def fish_for_priority(labels)
    fish_for(labels, /#{configatron.labels.priority}(\d+)/)
  end

  def fish_for(labels, regex)
    labels.each do |l|
      if l.name =~ regex
        return $1.to_i
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
          text_box story.priority_and_size, :at => [split_width, bounds.top], :width => (bounds.width - split_width), :height => height, :align => :right
        end
        stroke_horizontal_rule
      end
    end
  end

  def priority_and_size
    p = self.priority.nil? ? nil : "Priority: #{self.priority}"
    s = self.size.nil? ? nil : "Size: #{self.size}"
    [p,s].compact.join("\n")
  end

end

password = ask("Enter password: ") { |q| q.echo = false }
client = Octokit::Client.new(:login => configatron.github.user, :password => password)
puts "Getting issues from Github..."
issues = []
page = 0
begin
  page = page +1
  temp_issues = client.list_issues("#{configatron.github.project}", :state => "open", :page => page)
  unless configatron.filter.label.empty?
    temp_issues.select! {|i| i['labels'].to_s =~ /#{configatron.filter.label}/}
  end
  issues.push(*temp_issues)
end while not temp_issues.empty?

stories = issues.collect do |issue|
  UserStory.new(issue)
end

pdf = Prawn::Document.generate("user_stories.pdf", :page_layout => configatron.layout.page, :page_size => 'A4') do
  font "Helvetica"
  define_grid(:columns => configatron.layout.columns, :rows => configatron.layout.rows, :gutter => configatron.layout.gutter)
  stories.each_with_index do |story, index|
    j = (index % configatron.layout.columns)
    i = (index / configatron.layout.columns) % configatron.layout.rows
    grid(i,j).bounding_box do
      instance_exec(&UserStory.header(story))
      instance_exec(&UserStory.body(story))
    end
    if (((index + 1) % (configatron.layout.columns * configatron.layout.rows)) == 0)
      start_new_page
    end
  end
end

