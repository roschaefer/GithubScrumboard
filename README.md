# USAGE
1. create .github2scrum.rb configuration file, e.g.

    configatron.github.user = "teamaker"
    configatron.github.project = "teamaker/github_scrumboard"

2. label your issues with "USERSTORY", optionally with "P3","H5" for a priority of 3 and 5 estimated hours
3. run

    ruby github_scrumboard.rb

and enter your password
3. print file user_stories.pdf
