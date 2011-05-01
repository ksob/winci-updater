require File.dirname(__FILE__) + "/spec_helper"

describe WinCI::Updater::Git do

  before(:all) do
    FileUtils.rm_rf File.expand_path('spec/fixtures/tmp/')
    FileUtils.mkdir File.expand_path('spec/fixtures/tmp/')
    FileUtils.cp_r(File.expand_path('spec/fixtures/files.git'), File.expand_path('spec/fixtures/tmp/'))

    File.open('spec/fixtures/_config.yaml', 'w') do |f|
      f.puts ":SCMs:"
      f.puts "- \"#{File.expand_path('spec/fixtures/tmp/files.git')}\""
    end

    @git = WinCI::Updater::Git.new "spec/fixtures/_config.yaml"
    @git.setup_ssh_key "spec/fixtures/key"
  end

  context "provide for the 1st time (cloning)" do
    it "returns success message" do
      res = @git.provide File.expand_path('spec/fixtures/tmp'), 'files_cloned', false
      res.should =~ /success/i
    end

    it "builds files repository" do
      File.exists?(File.expand_path('spec/fixtures/tmp/files_cloned/.git/')).should be_true
    end
  end

  context "provide for the 2nd time when NO changes on source (pulling - Already up to date)" do
    it "returns success message" do
      res = @git.provide File.expand_path('spec/fixtures/tmp'), 'files_cloned', false
      res.should =~ /success/i
    end
  end

  context "provide for the 3rd time when there ARE changes on source (pulling - fetch&merge)" do
    before(:all) do
      FileUtils.rm_rf File.expand_path('spec/fixtures/tmp/files.git')
      FileUtils.cp_r(File.expand_path('spec/fixtures/files_changed.git'), File.expand_path('spec/fixtures/tmp/files.git'))
    end

    it "returns success message" do
      res = @git.provide File.expand_path('spec/fixtures/tmp'), 'files_cloned', false
      res.should =~ /success/i
    end
  end

end