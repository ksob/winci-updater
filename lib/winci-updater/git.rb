require 'rubygems'
require 'dl'
require 'yaml'

require "optparse"
require "date"
require "pathname"
require "fileutils"
require "git"

require 'winci-updater/git_ext/git'
require 'winci-updater/git_ext/lib'
require 'winci-updater/git_ext/base'
require 'winci-updater/core_ext/string'
require 'winci-updater/const'
require 'winci-updater/logger'

module WinCI
  module Updater
    class Git
      def initialize config_path="_config.yaml"
        @config = YAML.load_file(config_path)

        # create new log file periodically -- each month/week/day
        $log = TLogger.new(LOG_FILE, 'monthly', STDOUT, true) # possible values: 'monthly', 'weekly', 'daily'
        # limit the output
        $log.level = LOGGER_LEVEL

        $log.info("\r\n\r\n\r\nStarting script...\r\n\r\n")

        ensure_git_available
      end

      def ensure_git_available
        if File.exists?("../PortableGit/bin/git.exe")
          git_dir = File.expand_path('../PortableGit/bin', File.dirname(__FILE__))
          ENV['PATH'] = ENV['PATH'] + ';' + git_dir
        else
          # check if git.exe is on PATH
          begin
            `git status`
          rescue
            raise "Cannot find Git installation! Please reinstall using Git-1.7.0.2-preview20100309.exe or simmilar file!\r\n" +
                      "The file can be obtained from here: http://code.google.com/p/msysgit/downloads"
          end
        end
      end

      def setup_ssh_key key_path="key"
        res = ::Git.setup_ssh_key key_path
        if not res
          res = 'Error while creating ssh-agent or adding ssh key!'
        end
        raise res if not res['Identity added']
        @ssh_agent_enabled = true
      end

      def provide_scm scm, localPath
        if File.directory?(localPath)
          $log.info("\r\nUpdating '#{localPath}' repository")
          g = ::Git.open(localPath, :log => $log)
          # before overwriting with pull, here we do backup of any user made changes to files in the repo
          res = g.stash(:save => true, :message => 'Changes made by user')
          if not res.match_any? TOLERATED_STASH_MESSAGES then
            @not_tolerated_messages << res
            return
          end

          # update the repo
          # Note: this command can return 'Already up to date' message
          res = g.pull("origin", "origin/master")
          if not res.match_any? TOLERATED_PULL_MESSAGES then
            @not_tolerated_messages << res
            return
          end
        else # we clone it if it doesnt exist yet
          $log.info("\r\nCloning '#{localPath}' repository")
          opts = {}
          opts[:depth] = 1
          g = ::Git.clone(scm, localPath, opts)
        end
      end

      def provide target_dir = "./", target_repo_name = nil, handle_failure = true
        @not_tolerated_messages = []

        begin

          @config[:SCMs].each do |scm|
            begin
              target_repo_name = File.basename(scm, '.*') if not target_repo_name
              provide_scm(scm, File.join(target_dir, target_repo_name))
            rescue ::Git::GitExecuteError => e
              @not_tolerated_messages << e
            end
          end

          msg = ''
          buttons = MB_SETFOREGROUND | MB_OK
          if @not_tolerated_messages.length > 0
            msg = "Unknown message received while updating, please consult developement team.\r\n"+
                "It is possible that the message means success.\r\n"+"DETAILS:\r\n" + @not_tolerated_messages.join("\r\n")
            buttons = MB_ICONERROR | buttons
          else
            msg = "Update Successful!"
          end

          $log.info("\r\n\r\nSUMMARY:\r\n")
          $log.info(msg)
          if handle_failure
            puts msg
            message_box(msg, UPDATER_WINDOW_TITLE, buttons)
          else
            return msg
          end

        rescue => e
          msg = e.message.gsub('uncaught throw ', '')
          $log.error(msg)
          if handle_failure
            puts msg
            message_box("Update Failed! #{msg}", UPDATER_WINDOW_TITLE, buttons=MB_OK | MB_SETFOREGROUND | MB_ICONERROR)
          else
            raise
          end
        ensure
          ::Git.kill_ssh_agent if @ssh_agent_enabled
          @ssh_agent_enabled = nil
        end
      end

    end
  end
end
