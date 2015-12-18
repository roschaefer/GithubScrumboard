@wip
Feature: Invalid Settings
  As a user
  I want to be warned if I misconfigured my tool
  So I can fix it

  Scenario: Empty prefix pattern for story details
    Given a file named "github_scrumboard.yml" with:
    """
    issues:
      prefix:
        details: ""
    """
    When I run `github_scrumboard`
    Then the output should contain "Invalid configuration"
    And the output should contain "prefix pattern is empty"
    And the exit status should be 1

  Scenario: Unrecognized story state
    Given a file named "github_scrumboard.yml" with:
    """
    stories:
      state: something
    """
    When I run `github_scrumboard`
    Then the output should contain "Invalid configuration"
    And the output should contain "story state"
    And the exit status should be 1
