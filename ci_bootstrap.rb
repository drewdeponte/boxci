#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'fileutils'
require 'net/ssh'
require 'net/scp'

class CiBoostrap
  attr_accessor :root_path, :workspace, :rev, :config

  def initialize(workspace, rev)
    @workspace = workspace
    @rev = rev
    @root_path = File.dirname(File.expand_path(__FILE__))
    load_config
  end

  def run
    @report_location = File.join(@workspace, "reports")
    @project_folder = File.join(root_path, "#{@config["project_name"]}#{@rev}")
    `mkdir #{@project_folder}`

    Dir.chdir(@workspace)
    `git checkout #{@rev}`
    `git submodule update --init`
    `tar cf #{File.join(@project_folder, "project.tar")} --exclude .git --exclude "*.log" .`
    Dir.chdir(@root_path)
    write_vagrant_file
    STDOUT.sync = true

    Dir.chdir @project_folder do
      if @config["provider"] == "aws"
        install_aws_plugin
      else
        install_openstack_plugin
      end
      install_dummy_box unless dummy_box?
      puts `vagrant up --no-provision --provider #{@config["provider"]}`
      `vagrant ssh-config > ssh-config.local`
      Net::SSH.start("default", "ubuntu", {:config => "ssh-config.local"}) do |ssh|
        puppet = ssh.exec! "which puppet"
        unless puppet
          puts "Installing puppet"
          ssh.exec! "sudo apt-get --yes update && sudo apt-get --yes install puppet"
        end
        puts `vagrant provision`
        ssh.scp.upload! "project.tar", "/tmp/project.tar"
        write_test_runner
        puts "Uploading test runner"
        ssh.scp.upload! "test_runner.sh", "/tmp/test_runner.sh"
        puts ssh.exec! "chmod a+x /tmp/test_runner.sh"
        puts "Running tests"
        puts ssh.exec! "/tmp/test_runner.sh"
        FileUtils.mkdir_p(@report_location)
        Dir["#{@report_location}/*.xml"].each { |file| FileUtils.rm(file) }
        ssh.scp.download! "/tmp/reports", @workspace, :recursive => true
      end
    end
    cleanup
  end

  def load_config
    config_file = File.join(@workspace, ".ci_bootstrap.yml") 
    @config = YAML::load_file(config_file)
    @provider_config = YAML::load_file(File.join(root_path, "provider_config.yml"))
    @config[@config["provider"]] = @provider_config[@config["provider"]].merge(@config[@config["provider"]] || {})
    @config['puppet_path'] = File.join(@workspace, @config['puppet_folder'])
  end

  def cleanup
    Dir.chdir @project_folder
    `vagrant destroy`
    Dir.chdir(@root_path)
    FileUtils.rm_rf(@project_folder)
  end

  def vagrant?
    system("which vagrant")
  end

  def has_plugin?(plugin)
    system("vagrant plugin list | grep -q #{plugin}")
  end

  def aws_plugin?
    has_plugin?("vagrant-aws")
  end

  def openstack_plugin?
    has_plugin?("vagrant-openstack-plugin")
  end

  def install_plugin(plugin)
    `vagrant plugin install #{plugin}`
  end

  def install_aws_plugin
    install_plugin("vagrant-aws")
  end

  def install_openstack_plugin
    install_plugin("vagrant-openstack-plugin")
  end

  def dummy_box?
    system("vagrant box list | grep -q dummy")
  end

  def install_dummy_box
    `vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box`
  end

  def write_vagrant_file
    template_file = File.join(@root_path, "templates", "Vagrantfile.#{@config["provider"]}.erb")
    template = ERB.new(File.read(template_file), 0, "<>")
    File.write(File.join(@project_folder, "Vagrantfile"), template.result(binding))
  end
  
  def write_test_runner
    template_file = File.join(@root_path, "templates", "#{@config['type']}_test_runner.sh.erb")
    template = ERB.new(File.read(template_file), 0, "<>")
    File.write(File.join(@project_folder, "test_runner.sh"), template.result(binding), "perm" => 0755)
  end
end

@workspace = ARGV[0]
@rev = ARGV[1] || "HEAD"
@bootstrap = CiBoostrap.new(@workspace, @rev)
@bootstrap.run



