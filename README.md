# GithubScrumboard

TODO: Write a gem description

## Installation

TODO: Write a description

<!--Add this line to your application's Gemfile:-->

    <!--gem 'github_scrumboard'-->

<!--And then execute:-->

    <!--$ bundle-->

<!--Or install it yourself as:-->

    <!--$ gem install github_scrumboard-->

### Requirements

* printer

## Usage
1. label your issues with "USERSTORY", you can optionally specify a size or a priority with labels "H5" (~"Hours") and "P2" (~"Priority")
2. run ```ruby github_scrumboard.rb```
3. print file "user_stories.pdf"

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
