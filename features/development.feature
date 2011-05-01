Feature: Development processes of winci-updater itself (rake tasks)

  As a winci-updater maintainer or contributor
  I want rake tasks to maintain and release the gem
  So that I can spend time on the tests and code, and not excessive time on maintenance processes

  Scenario: Generate RubyGem
    Given this project is active project folder
    When I invoke task "rake build"
    Then file with name matching "pkg/winci-updater-*.gem" is created
    And file with name matching "winci-updater.gemspec" is created
    And the file "winci-updater.gemspec" is a valid gemspec

