Feature: Invalid Settings
  As a developer
  I want to run github_scrumboard --help
  in order to learn how to use the tool

  Scenario:
    When I run `github_scrumboard --help`
    Then I should see a help page like this:
    """
    Github Scrumboard is a tool to create pdfs from your github issues.
    After creating the pdf, you can print the issues, cut them out and put them on a physical scrum board.
    [...]
    Further information:
      https://github.com/roschaefer/github_scrumboard
    """
