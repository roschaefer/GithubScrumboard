@wip
Feature: Verbose output
  As a developer
  I want to run github_scrumboard --verbose
  In order to see the final configuration of the tool

  Scenario: Run with verbose switch
    When I run `github_scrumboard --verbose`
    Then I should see my final configuration e.g. like this:
    """
    page:
      layout: landscape
      size: A4
    [...]
    issues:
      prefix:
        estimation: H
        priority: P
        details: "~"
      filter: USERSTORY
    """
  Scenario: Local configuration merges with default configuration
    Given I have a local 'github_scrumboard.yml' with the following content:
    """
    github:
      login: my_login
      project: my_repository
    page:
      size: A3
    """
    When I run `github_scrumboard --verbose`
    Then I should see my final configuration e.g. like this:
    """
    github:
      login: my_login
      project: my_repository
    [...]
    page:
      layout: landscape
      size: A3
    """
