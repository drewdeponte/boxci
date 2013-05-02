require 'fileutils'
require 'net/ssh'
require 'net/scp'

module CIBootstrap
  class SSHService
    attr_reader :config, :session, :config_file

    def initialize(config_file)
      @config_file = config_file
      @config = Net::SSH::Config.load(@config_file)
      @session = Net::SSH.start("default", @config["user"], {:config => @config_file})
      
      return self
    end

    def run_remote_command(command)
      @session.exec! command
    end

    def upload_file(local_path, remote_path)
      @session.scp.upload! local_path, remote_path
    end

    def download_file(remote_path, local_path)
      @session.scp.download! remote_path, local_path
    end

    def download_folder(remote_folder, local_folder)
      @session.scp.download! remote_folder, local_folder, :recursive => true
    end
  end
end
