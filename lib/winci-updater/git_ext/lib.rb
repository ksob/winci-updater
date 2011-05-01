require 'tempfile'

module Git

  class GitExecuteError < StandardError
  end

  class Lib

    # open ssh-agent and add ssh_key
    def setup_ssh_key(ssh_key_path)
      envStr = os_command('ssh-agent', [], false)
      envVars = envStr.split(';')
      envVars.each do |var|
        pair = var.split('=')
        if pair and pair.length == 2
          ENV[pair[0].strip] = pair[1].strip if pair[0] and pair[1]
        end
      end
      arr_opts = []
      arr_opts << ssh_key_path
      os_command('ssh-add', arr_opts, false)
    end

    def kill_ssh_agent
      os_command('ssh-agent -k', [], false)
    end

    def show_head_names
      command('show', ['--name-only'])
    end

    # tries to clean the given repo
    def clean(opts = {})
      @path = opts[:path] || '.'

      arr_opts = []
      arr_opts << "-o" << opts[:remote] if opts[:remote]
      arr_opts << "-f" << opts[:filter] if opts[:filter]

      command('clean', arr_opts)
    end

    def stash(opts = {})
      @path = opts[:path] || '.'

      arr_opts = []
      arr_opts << "-o" << opts[:remote] if opts[:remote]
      arr_opts << 'save' if opts[:save]

      arr_opts << '--'
      arr_opts << opts[:message] if opts[:message]

      command('stash', arr_opts)
    end

    def os_command(cmd, opts = [], chdir = true, redirect = '', &block)
      ENV['GIT_DIR'] = @git_dir
      ENV['GIT_INDEX_FILE'] = @git_index_file
      ENV['GIT_WORK_TREE'] = @git_work_dir
      path = @git_work_dir || @git_dir || @path

      opts = [opts].flatten.map { |s| escape(s) }.join(' ')
      git_cmd = "#{cmd} #{opts} #{redirect} 2>&1"

      out = nil
      if chdir && (Dir.getwd != path)
        Dir.chdir(path) { out = run_command(git_cmd, &block) }
      else
        out = run_command(git_cmd, &block)
      end

      @logger = $log if not @logger
      if @logger
        @logger.info(git_cmd)
        @logger.debug(out)
      end

      if $?.exitstatus > 0
        if $?.exitstatus == 1 && out == ''
          return ''
        end
        raise Git::GitExecuteError.new(git_cmd + ':' + out.to_s)
      end
      out
    end

    def command(cmd, opts = [], chdir = true, redirect = '', &block)
      ENV['GIT_DIR'] = @git_dir
      ENV['GIT_INDEX_FILE'] = @git_index_file
      ENV['GIT_WORK_TREE'] = @git_work_dir
      path = @git_work_dir || @git_dir || @path

      opts = [opts].flatten.map { |s| escape(s) }.join(' ')
      git_cmd = "git #{cmd} #{opts} #{redirect} 2>&1"

      out = nil
      if chdir && (Dir.getwd != path)
        Dir.chdir(path) { out = run_command(git_cmd, &block) }
      else
        out = run_command(git_cmd, &block)
      end

      @logger = $log if not @logger
      if @logger
        @logger.info(git_cmd)
        @logger.debug(out)
      end

      if $?.exitstatus > 0
        if $?.exitstatus == 1 && out == ''
          return ''
        end
        raise Git::GitExecuteError.new(git_cmd + ':' + out.to_s)
      end
      out
    end

  end
end
