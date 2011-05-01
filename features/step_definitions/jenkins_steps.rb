Given /^I have WinCI\-server installed in "([^\"]*)"$/ do |winci_server_path|
  @winci_server_path = winci_server_path

  # below file gets created after running winci-server/install.bat
  File.exists?(File.join(winci_server_path, "ruby/bin/ruby.exe")).should == true
end

When /^I have a Jenkins server running$/ do
  require 'socket'
  require 'net/http'
  begin
    print "."; $stdout.flush
    Net::HTTP.start("localhost", "3010") { |http| http.get('/') }
  rescue Exception => e
    system "rake --rakefile #{File.join(@winci_server_path, "restart_jenkins.rake")} restart_jenkins"
  ensure
  end
end

When /^there exist job named "([^\"]*)" that pushes successful build to "([^\"]*)" repo$/ do |project_name, production_repo|
  @project_name = project_name

  FileUtils.rm_rf File.expand_path('var/')
  FileUtils.mkdir File.expand_path('var/')
  FileUtils.cp_r(File.expand_path('features/fixtures/files.git'), File.expand_path('var/'))

  # TODO move to separate step
  # prepare production repo
  FileUtils.mkdir File.expand_path(File.dirname(production_repo))
  FileUtils.cp_r(File.expand_path('features/fixtures/files.git'), File.expand_path(production_repo))

  # create job config
  cfg = Jenkins::JobConfigBuilder.new(:ruby) do |c|
    c.scm = File.expand_path('var/files.git') #"C:/repos/#{@project_name}.git"
    c.steps = [
        # below makes sense when your Rakefile run rspec/cucumber by default
    [:build_bat_step, "bundle exec rake"],
    # this will send current code to production repo only after rspec/cucumber passed
    [:build_bat_step, "git push #{File.expand_path(production_repo)} HEAD:master"]
    ]
  end

  job = WinCI::Job.new @project_name, cfg


  print "waiting for at most 30 seconds for the server to create the job"
  tries = 0
  begin
    print "."; $stdout.flush
    tries += 1

    # by default creates job on localhost:3010
    @job_creation_res = job.create
    raise if not @job_creation_res =~ /.*project created on jenkins.*/

    sleep(10)
    puts ""
  rescue Exception => e
    if tries <= 3
      sleep 2
      retry
    end
  ensure
  end

  @job_creation_res.should =~ /.*project created on jenkins.*/
end

When /^the job has at least one successful build$/ do
  job = WinCI::Job.new @project_name
  sha = nil
  begin
    sha = job.last_successful_build_sha
  rescue
    Jenkins::Api.build_job(@project_name)
    puts "waiting 40 seconds for the server to build the job"
    sleep 40
    sha = job.last_successful_build_sha
  end
  sha.should_not be_empty
end

When /^I run updater with "([^\"]*)" in config$/ do |production_repo|
  File.open('var/_config.yaml', 'w') do |f|
    f.puts ":SCMs:"
    f.puts "- \"#{File.expand_path(production_repo)}\""
  end

  @git = WinCI::Updater::Git.new "var/_config.yaml"
  @git.setup_ssh_key "spec/fixtures/key"

  @updater_res = @git.provide File.expand_path('var/'), 'files_cloned', false
end

When /^I run updater with "([^\"]*)" in config and target dir "([^\"]*)" as parameter$/ do |production_repo, target_dir|
  File.open(File.expand_path('var/_config.yaml'), 'w') do |f|
    f.puts ":SCMs:"
    f.puts "- \"#{File.expand_path(production_repo)}\""
  end

  @git = WinCI::Updater::Git.new "var/_config.yaml"
  @git.setup_ssh_key "spec/fixtures/key"

  @updater_res = @git.provide File.expand_path('var/'), 'files_cloned', false
end

Then /^I should see this$/ do |text|
  @updater_res.strip.upcase.should contain(text.strip.upcase)
end

When /^directory named "([^\"]*)" is created$/ do |arg1|
  File.exists?(File.expand_path('var/files_cloned/.git/')).should be_true
end