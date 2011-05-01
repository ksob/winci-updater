Feature: Works with WinCI continuous delivery process
  In order to enhance provisioning in continuous delivery process
  As a project developer
  I want to fully integrate updater with WinCI continuous delivery process

  Background:
    Given I have WinCI-server installed in "C:/winci-server"
    And I have a Jenkins server running
    And there exist job named "files" that pushes successful build to "var/production/files.git" repo
    And the job has at least one successful build

  Scenario: Download last successful build
    When I run updater with "var/production/files.git" in config and target dir "files_cloned" as parameter
    Then I should see this
    """
    Update successful!
    """
    And directory named "files_cloned" is created
