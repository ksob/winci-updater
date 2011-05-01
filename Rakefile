require 'bundler'
Bundler::GemHelper.install_tasks

Dir['tasks/**/*.rake'].each { |f| load f }

desc "Run RSpec examples; Run cucumber:ok;"
task :default => [:spec, :features]
