Feature: Verbose output
  As a developer
  I want to run github_scrumboard with verbosity
  In order to see the final configuration of the tool

  Scenario: Run with verbose switch
    When I run `github_scrumboard --verbose`
    Then I should see my final configuration e.g. like this:
    """
      size: A4
    [...]
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
    Then I my final configuration should merge default and local settings:
    """
      login: my_login
      project: my_repository
    [...]
      size: A3
    [...]
        estimation: H
        priority: P
        details: "~"
      filter: USERSTORY
    """
