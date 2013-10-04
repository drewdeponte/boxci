#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'erb'
require 'fileutils'
require 'net/ssh'
require 'net/scp'

class CiBoostrap
  attr_accessor :root_path, :workspace, :rev, :config, :report_location

  def initialize(workspace, rev)
    @workspace = workspace
    @rev = rev
    @root_path = File.dirname(File.expand_path(__FILE__))
    @report_location = File.join(@workspace, "reports")
    load_config
  end

  def run
    @project_folder = File.join(root_path, "#{@config["project_name"]}#{@rev}")
    `mkdir #{@project_folder}`

    Dir.chdir(@workspace)
    `git checkout #{@rev}`
    `git submodule init`
    `git submodule update`
    `tar cf #{File.join(@project_folder, "project.tar")} --exclude .git --exclude "*.log" --exclude node_modules .`
    if (File.exists?('.ruby-version'))
      File.cp('.ruby-version',@workspace)
    end
    Dir.chdir(@root_path)
    write_vagrant_file
    STDOUT.sync = true

    Dir.chdir @project_folder do
      if @config["provider"] == "aws"
        install_aws_plugin
        install_aws_dummy_box unless dummy_aws_box?
      else
        install_openstack_plugin
        install_openstack_dummy_box unless dummy_openstack_box?
      end
      run_cmd_and_show("vagrant up --no-provision --provider #{@config["provider"]}")
      `vagrant ssh-config > ssh-config.local`
      Net::SSH.start("default", "ubuntu", {:config => "ssh-config.local"}) do |ssh|
        ssh.exec!  "mkdir /vagrant/#{@config['project_name']}"
        ssh.exec!  "tar xf /vagrant/project.tar -C /vagrant/#{@config['project_name']}"
        ssh.exec!  "cp /vagrant/#{@config["project_name"]}/.ruby-version /vagrant"
        puppet = ssh.exec! "which puppet"
        unless puppet
          puts "Installing puppet"
          ssh.exec! "sudo apt-get --yes update && sudo apt-get --yes install puppet"
        end
      end

      run_cmd_and_show("vagrant provision")

      Net::SSH.start("default", "ubuntu", {:config => "ssh-config.local"}) do |ssh|
        report_exts = @config['report_file_ext'] || ['xml']
        report_exts.each{ |ext|
          ssh.exec!  "mkdir -p /vagrant/#{@config['project_name']}/reports/#{ext}"
        }
        write_test_runner
        puts "Uploading test runner"
        ssh.scp.upload! "test_runner.sh", "/vagrant/test_runner.sh"
        puts ssh.exec! "chmod a+x /vagrant/test_runner.sh"
        puts "Running tests"
        puts ssh.exec! "/vagrant/test_runner.sh"
        FileUtils.mkdir_p(@report_location)
        Dir["#{@report_location}/*.*"].each { |file| FileUtils.rm(file) }
        ssh.scp.download! "/vagrant/#{config['project_name']}/reports", @workspace, :recursive => true
      end
    end
  ensure
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

  def dummy_box?(type)
    system("vagrant box list | grep -q \"dummy (#{type})\"")
  end

  def dummy_aws_box?
    dummy_box?("aws")
  end

  def dummy_openstack_box?
    dummy_box?("openstack")
  end

  def install_aws_dummy_box
    `vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box`
  end

  def install_openstack_dummy_box
    `vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box` 
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

  def run_cmd_and_show(cmd)
    IO.popen(cmd) { |f| f.each { |l| puts l } }
  end
end

@workspace = ARGV[0]
@rev = ARGV[1] || "HEAD"
@bootstrap = CiBoostrap.new(@workspace, @rev)
@bootstrap.run



