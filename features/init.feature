Feature: Configuration Generator
  As a beginner
  I want to generate a configuration.yml with defaults in the current directory in one command
  to see the possible options and edit them.

  Scenario: Creating a github_scrumboard.yml
    When I run `github_scrumboard --init`
    Then a file called `github_scrumboard.yml` is placed in the current directory
    And the file has (roughly) the following content:
    """
    page:
      layout: landscape
      size: A4
    grid:
    [...]
    issues:
    [...]
    output:
    [...]
    logger_level: debug
    stories:
    [...]
    github:
      login: # My github user login
      project: # Github repository, e.g. roschaefer/github_scrumboard
    """
