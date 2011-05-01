module Git

  class Base

    def self.setup_ssh_key(ssh_key_path)
      Git::Lib.new.setup_ssh_key(ssh_key_path)
    end

    def self.kill_ssh_agent
      Git::Lib.new.kill_ssh_agent
    end

    def show_head_names
      self.lib.show_head_names
    end

    # cleans a git repository locally
    def clean(opts = {})
      # run git-clone
      self.lib.clean(opts)
    end

    def stash(opts = {})
      # run git-stash
      self.lib.stash(opts)
    end

  end

end
