Feature: Watermark
  As a developer
  I would like to see a watermark on a story that is already finished
  in order to distinguish finished from unfinished user stories

	@vcr
  Scenario: Open issues by default
    Given I have some open and closed issues in my github repository
    And I use the default configuration
		And let's say, I won't be asked for my github credentials
    When I run `github_scrumboard`
    Then I should see only open issues in the output pdf

	@vcr
  Scenario: Only closed issues
    Given I have some open and closed issues in my github repository
    And I have a local 'github_scrumboard.yml' with the following content:
    """
    stories:
      state: done
    """
		And let's say, I won't be asked for my github credentials
    When I run `github_scrumboard`
    Then I should see only closed issues in the output pdf
    And I can see a big watermark saying "DONE" in the output pdf

	@vcr
  Scenario: Both open and closed issues
    Given I have some open and closed issues in my github repository
    And I have a local 'github_scrumboard.yml' with the following content:
    """
    stories:
      state: all
    """
		And let's say, I won't be asked for my github credentials
    When I run `github_scrumboard`
    Then I should see both open and closed issues in the output pdf
