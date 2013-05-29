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
    Then the output should contain "ERROR"
    And the exit status should be 1
