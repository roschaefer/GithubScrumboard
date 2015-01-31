# GithubScrumboard
[![Build Status](https://travis-ci.org/roschaefer/GithubScrumboard.png)](https://travis-ci.org/roschaefer/GithubScrumboard)

Manage your github issues like user stories and print them. Cut the sheets of paper along the cutting lines. Put your user stories on a physical scrum board.

![user stories](https://raw.github.com/roschaefer/GithubScrumboard/master/user_stories.png)


## Installation

It's not released yet, so you have to install it manually:

1. ```git clone git://github.com/roschaefer/GithubScrumboard.git```
2. ```cd GithubScrumboard```
3. ```bundle install```
4. ```rake install```

## Usage
1. label your issues with ```USERSTORY```, you can optionally specify a size or a priority with labels ```H5``` (5 estimated Hours) and ```P2``` (Priority Level 2)
2. run ```github_scrumboard.rb```
3. print ```user_stories.pdf```

### Configuration
* create github_scrumboard.yml, e.g.
<pre><code>github:
      login: GITHUB_LOGIN
      project: PROJECT_ON_GITHUB
</code></pre>

Check out the current [application defaults](lib/github_scrumboard/defaults.yml) to see the full list of available options
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
