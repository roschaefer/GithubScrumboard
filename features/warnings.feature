Feature: Invalid Settings
  As a user
  I want to be warned if I misconfigured my tool
  So I can fix it

  Scenario: Empty story details prefix
    Given my connection with github will just do it
    And my setting "issues.prefixes.details" is empty
    When I run "github_scrumboard"
    Then the output should contain "Error"
    And the tool will terminate
