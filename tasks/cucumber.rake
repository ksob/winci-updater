begin
  namespace :cucumber do
    require 'cucumber/rake/task'
    Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
      t.cucumber_opts = "--tags @wip"
    end
    Cucumber::Rake::Task.new(:ok, 'Run features that should be working') do |t|
      t.cucumber_opts = "--tags ~@wip"
    end
    task :all => [:ok, :wip]
  end

  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'
rescue LoadError
  task :cucumber do
    abort "Cucumber is not available. In order to run features, you must: gem install cucumber"
  end
end

desc 'Alias for cucumber'
task :features => 'cucumber'

