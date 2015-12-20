Before do
  setup_aruba
end

Before('@vcr') do
  aruba.config.command_launcher = :in_process
  aruba.config.main_class = VcrFriendlyMain
end

After('@vcr') do
  aruba.config.command_launcher = :spawn
end
