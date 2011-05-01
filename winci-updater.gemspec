# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "winci-updater/version"

Gem::Specification.new do |s|
  s.name        = "winci-updater"
  s.version     = WinCI::Updater::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kamil Sobieraj"]
  s.email       = ["ksob@rubyforge.org"]
  s.homepage    = ""
  s.summary     = %q{File updater capable of downloading files over Git (supports SSH)}
  s.description = %q{Introduces Agile technologies into provisioning process by keeping it integrated with Continuous Integration Server. To do so it incorporates Git DVCS into the process.}

  s.rubyforge_project = "winci-updater"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("git", ["~> 1.2.5"])
  s.add_development_dependency("rake", ["~> 0.8.7"])
  s.add_development_dependency("cucumber", ["~> 0.10.2"])
  s.add_development_dependency("rspec", ["~> 2.5.0"])
  s.add_development_dependency("jenkins-war", ["~> 1.401"])
  s.add_development_dependency("winci", ["~> 0.0.3"])
end
