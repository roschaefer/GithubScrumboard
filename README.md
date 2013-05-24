### Requirements
* printer

### Usage
1. label your issues with "USERSTORY", you can optionally specify a size with a label "H5" for 5 estimated hours or set a priority with a label "P2" respectively
2. run ```ruby github_scrumboard.rb```
3. print file "user_stories.pdf"

### Configuration
* create github_scrumboard.yml, e.g.
<pre><code>
github:
  login: MY_GITHUB_LOGIN
  project: MY_PROJECT_ON_GITHUB
page:
  layout: :landscape
  size: A4
grid:
  columns: 2
  rows: 2
  gutter: 30
issues:
  prefix:
    priority: P
    size: H
  filter: USERSTORY
output:
  file_name: user_stories.pdf
  font: Helvetica
</code></pre>
