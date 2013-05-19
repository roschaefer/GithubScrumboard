### USAGE
1. create .github2scrum.rb configuration file, e.g.
<pre><code>
  configatron.github.user = "teamaker"
  configatron.github.project = "teamaker/github_scrumboard"
</code></pre>

2. label your issues with "USERSTORY", optionally with "P3","H5" for a priority of 3 and 5 estimated hours
3. run
<pre><code>
    ruby github_scrumboard.rb
</code></pre>
4. print file "user_stories.pdf"
