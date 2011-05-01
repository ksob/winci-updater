module Git

  def self.setup_ssh_key(ssh_key_path)
    Base.setup_ssh_key(ssh_key_path)
  end

  def self.kill_ssh_agent
    Base.kill_ssh_agent
  end

  def self.show_head_names
    Base.show_head_names
  end

end
