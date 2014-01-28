#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'fileutils'
require 'net/ssh'
require 'net/scp'

class AMIBuilder
  attr_accessor :root_path, :workspace, :name, :config

  def initialize(workspace, name)
    @workspace = workspace
    @name = name
    @root_path = File.dirname(File.expand_path(__FILE__))
    load_config
  end

  def run
    @project_folder = File.join(root_path, "#{@config["project_name"]}_ami_builder")
    `mkdir #{@project_folder}`
    Dir.chdir(@workspace)
    `git archive --format tar HEAD > #{File.join(@project_folder, "project.tar")}`
    Dir.chdir(@root_path)
    write_vagrant_file
    STDOUT.sync = true

    Dir.chdir @project_folder do
      install_aws_plugin unless aws_plugin?
      install_dummy_box unless dummy_box?
      puts `vagrant up --no-provision --provider #{@config["provider"]}`
      `vagrant ssh-config > ssh-config.local`
      Net::SSH.start("default", "ubuntu", {:config => "ssh-config.local"}) do |ssh|
        ssh.exec! "sudo sed -i.dist 's,universe$,universe multiverse,' /etc/apt/sources.list"
        ssh.exec! "sudo apt-get --yes update"
        puts "Installing puppet"
        ssh.exec! "sudo apt-get --yes install puppet"
        puts `vagrant provision`
        ssh.exec! "sudo apt-get --yes install ec2-ami-tools ec2-api-tools"
        ssh.exec! "mkdir /tmp/certs"
        ssh.scp.upload! @provider_config["aws"]["private_keyfile"], "/tmp/certs/keyfile.pem"
        ssh.scp.upload! @provider_config["aws"]["certificate_file"], "/tmp/certs/cert.pem"
        @ami_commands = <<-EOF
        echo Bundling Volume
        sudo ec2-bundle-vol -k /tmp/certs/keyfile.pem -c /tmp/certs/cert.pem -u #{@provider_config["aws"]["user_id"]} -e /tmp/certs -r x86_64
        echo Uploading Bundle
        sudo ec2-upload-bundle -b #{@provider_config["aws"]["ami_bucket"]} -m /tmp/image.manifest.xml -a #{@provider_config["aws"]["access_key"]} -s #{@provider_config["aws"]["secret_access_key"]}
        echo Registering Bundle
        sudo ec2-register -K /tmp/certs/keyfile.pem -C /tmp/certs/cert.pem #{@provider_config["aws"]["ami_bucket"]}/image.manifest.xml -n #{@name} 
        EOF
        File.write("ami_commands.sh", @ami_commands)
        ssh.scp.upload! "ami_commands.sh", "/tmp/certs/ami_commands.sh"
        ssh.scp.upload! "project.tar", "/tmp/project.tar"
        write_test_runner
        puts "Uploading test runner"
        ssh.scp.upload! "test_runner.sh", "/tmp/test_runner.sh"
        puts ssh.exec! "chmod a+x /tmp/test_runner.sh"
      end
    end
  end

  def load_config
    config_file = File.join(@workspace, ".ci_bootstrap.yml") 
    @config = YAML::load_file(config_file)
    @provider_config = YAML::load_file(File.join(root_path, "provider_config.yml"))
    @config[@config["provider"]] = @provider_config[@config["provider"]] 
    @config['puppet_path'] = File.join(@workspace, @config['puppet_folder'])
  end

  def cleanup
    `vagrant destroy`
    Dir.chdir(@root_path)
    FileUtils.rm_rf(@project_folder)
  end

  def vagrant?
    system("which -s vagrant")
  end

  def aws_plugin?
    system("vagrant plugin list | grep -q vagrant-aws")
  end

  def install_aws_plugin
    `vagrant plugin install vagrant-aws`
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
@name = ARGV[1]
@builder = AMIBuilder.new(@workspace, @name)
@builder.run



