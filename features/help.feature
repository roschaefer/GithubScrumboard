@wip
Feature: Invalid Settings
  As a developer
  I want to run github_scrumboard --help
  in order to learn how to use the tool

  Scenario:
    When I run `github_scrumboard --help`
    Then I should see a help page like this:
    """
    Github Scrumboard lets you create a pdf of all your open issues on github
    to cut them and pin them on a physical scrumboard.

    Usage:
      github_scrumboard [project_directory]
      github_scrumboard -h/--help
      github_scrumboard init

    Further information:
      https://github.com/roschaefer/github_scrumboard
    """
