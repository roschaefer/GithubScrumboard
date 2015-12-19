def check_output_roughly_matches(output)
  output.split("[...]\n").each do |part|
    expect(@command).to have_output an_output_string_matching(part)
  end
end

Then(/^I should see a help page like this:$/) do |output|
  check_output_roughly_matches(output)
end

When(/^I run `(.+)`$/) do |command|
  cmd = sanitize_text(command)
  @command = run(cmd, :fail_on_error => false, :exit_timeout => 1)
end

Given(/^a file named "(.*?)" with:$/) do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

Then(/^the output should contain "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the exit status should be (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my final configuration e\.g\. like this:$/) do |output|
  check_output_roughly_matches(output)
end

Given(/^I have a local 'github_scrumboard\.yml' with the following content:$/) do |content|
  write_file('github_scrumboard.yml', content)
end

Then(/^I my final configuration should merge default and local settings:$/) do |output|
  check_output_roughly_matches(output)
end

Then(/^a file called `github_scrumboard\.yml` is placed in the current directory$/) do
  @file_path = "github_scrumboard.yml"
  expect(@file_path).to be_an_existing_file
end

Then(/^the file has \(roughly\) the following content:$/) do |content|
  content.split("[...]\n").each do |part|
    expect(@file_path).to have_file_content file_content_including(part.chomp)
  end
end


