Then(/^I should see a help page like this:$/) do |output|
  output.split("[...]\n").each do |part|
    expect(@command).to have_output an_output_string_matching(part)
  end
end

When(/^I run `(.+)`$/) do |command|
  cmd = sanitize_text(command)
  @command = run(cmd, :fail_on_error => false)
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



