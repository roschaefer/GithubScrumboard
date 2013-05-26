# GithubScrumboard

Don't bother to use any online tools for agile development. Regard your github issues as user stories and print them out for use on a physical scrumboard.

## Installation

This gem is not released yet, so you have to install it manually:
1. git clone git://github.com/teamaker/github_scrumboard.git
2. cd github_scrumboard
3. rake install

<!--Add this line to your application's Gemfile:-->

<!--    gem 'github_scrumboard'-->

<!--And then execute:-->

<!--    $ bundle-->

<!--Or install it yourself as:-->

<!--    $ gem install github_scrumboard-->

### Optional requirements

* printer

## Usage
1. label your issues with "USERSTORY", you can optionally specify a size or a priority with labels "H5" ("Hours") and "P2" ("Priority")
2. run ```github_scrumboard.rb```
3. print "user_stories.pdf"

### Configuration
* create github_scrumboard.yml, e.g.
<pre><code>github:
      login: MY_GITHUB_LOGIN
      project: MY_PROJECT_ON_GITHUB
    page:
      layout: :landscape
      size: A4
    grid:
      columns: 2
      rows: 2
      gutter: 30
    issues:
      prefix:
        priority: P
        estimation: H
      filter: USERSTORY
    output:
      file_name: user_stories.pdf
      font: Helvetica
</code></pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
