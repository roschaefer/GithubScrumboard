def check_output_roughly_matches(output)
  output.split("[...]\n").each do |part|
    expect(@command).to have_output an_output_string_matching(part)
  end
end

def text_of_user_stories
  user_stories_path = Pathname(aruba.config.working_directory).join("user_stories.pdf")
  user_stories_txt_path = Pathname(aruba.config.working_directory).join("user_stories.txt")
  `pdftotext #{user_stories_path.to_s}` # ugly but necessary
  IO.read(user_stories_txt_path)
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

Given(/^I have some open and closed issues in my github repository$/) do
  # assuming the vcr cassettes are used
	@expected_open_issues_text = "I want show the assignee on a printed user story"
	@expected_closed_issues_text = "I would like to see a watermark on a story"
end

Given(/^I use the default configuration$/) do
  # no implementation
end

Then(/^I should see only open issues in the output pdf$/) do
	expect(text_of_user_stories).to include(@expected_open_issues_text)
	expect(text_of_user_stories).not_to include(@expected_closed_issues_text)
end

Then(/^I should see only closed issues in the output pdf$/) do
	expect(text_of_user_stories).to include(@expected_closed_issues_text)
	expect(text_of_user_stories).not_to include(@expected_open_issues_text)
end

Then(/^I can see a big watermark saying "DONE" in the output pdf$/) do
  ["D\n", "O\n", "N\n", "E\n"].each do |letter|
    expect(text_of_user_stories).to include(letter)
  end
end

Then(/^I should see both open and closed issues in the output pdf$/) do
	expect(text_of_user_stories).to include(@expected_closed_issues_text)
	expect(text_of_user_stories).to include(@expected_open_issues_text)
end

Given(/^let's say, I won't be asked for my github credentials$/) do
  content = {'github' => 
             { 'login' => 'roschaefer',
               'project' => 'roschaefer/github_scrumboard',
               'password' => "not_for_you"
             } }.to_yaml
  content.slice!("---")
  append_to_file('github_scrumboard.yml', content)
end

