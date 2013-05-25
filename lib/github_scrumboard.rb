require "github_scrumboard/version"

require 'prawn'
require 'octokit'
require 'highline/import'
require 'yaml'
require 'pry'
require 'mash'
require 'active_support/core_ext/hash/deep_merge'
module GithubScrumboard
  # Your code goes here...

DEFAULTS = <<EOS
#github:
  #login: MY_GITHUB_LOGIN
  #project: MY_PROJECT_ON_GITHUB
page:
  layout: :landscape
  size: A4
grid:
  columns: 2
  rows: 2
  gutter: 30
issues:
  prefix:
    estimation: H
    priority: P
  filter: USERSTORY
output:
  file_name: user_stories.pdf
  font: Helvetica
EOS

  config = YAML::load(DEFAULTS)

  custom_config = YAML::load(open("github_scrumboard.yml"))
  if custom_config
    config = config.deep_merge(custom_config)
  end

  C = Mash.new(config)

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
      self.extract(labels, /#{C.issues.prefix.estimation}(\d+)/)
    end

    def extract_priority(labels)
      self.extract(labels, /#{C.issues.prefix.priority}(\d+)/)
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
            text_box story.priority_and_estimation, :at => [split_width, bounds.top], :width => (bounds.width - split_width), :height => height, :align => :right
          end
          stroke_horizontal_rule
        end
      end
    end

    def priority_and_estimation
      p = self.priority.nil? ? nil : "Priority: #{self.priority}"
      e = self.estimation.nil? ? nil : "Size: #{self.estimation}"
      [p,e].compact.join("\n")
    end

    def self.backside(story)
      Proc.new do
        font_size(25) { text story.id}
      end
    end
  end

  unless C.github
    C.github = {}
  end

  [:login, :password, :project].each do |c|
    unless C.github.send(c)
      C.github.send("#{c}=", ask("Enter #{c}: ") { |q| q.echo = false if c == :password })
    end
  end

  client = Octokit::Client.new(:login => C.github.login, :password => C.github.password)
  puts "Getting issues from Github..."
  issues = []
  page = 0
  begin
    page = page +1
    temp_issues = client.list_issues(C.github.project, :state => "open", :page => page)
    unless C.issues.filter.empty?
      temp_issues.select! {|i| i['labels'].to_s =~ /#{C.issues.filter}/}
    end
    issues.push(*temp_issues)
  end while not temp_issues.empty?

  stories = issues.collect do |issue|
    UserStory.new(issue)
  end

  def pagination(index, grid, backside=false)
    i = (index / grid.rows) % grid.columns
    unless backside
      j = index % grid.columns
      return [i, j]
    else
      j = ( -1 -index) % grid.columns
      return [i, j]
    end
  end

  def print_cutting_lines(grid)
    y = bounds.top
    x = bounds.left
    w = bounds.width/grid.columns
    h = bounds.height/grid.rows

    dash(5, :space => 2)
    (grid.columns-1).times.each do
      x += w
      vertical_line 0, bounds.height, :at => x
    end

    (grid.rows-1).times.each do
      y += h
      horizontal_line 0, bounds.width, :at => y
    end
    undash
  end

  pdf = Prawn::Document.generate(C.output.file_name, :page_layout => C.page.layout, :size => C.page['size']) do
    font C.output.font
    define_grid(:rows => C.grid.rows, :columns => C.grid.columns, :gutter => C.grid.gutter)
    next_page = false
    stories.each_slice(C.grid.rows * C.grid.columns).to_a.each_with_index do |some_stories, index|
      start_new_page if next_page
      # FRONTSIDE
      some_stories.each_with_index do |story, index|
        i,j = pagination(index, C.grid)
        grid(i,j).bounding_box do
          instance_exec(&UserStory.header(story))
          instance_exec(&UserStory.body(story))
        end
      end
      # BACKSIDE
      start_new_page
      some_stories.each_with_index do |story, index|
        i,j = pagination(index, C.grid, backside=true)
        grid(i,j).bounding_box do
          instance_exec(&UserStory.backside(story))
        end
      end
      next_page = true
    end
  end

end
