require 'spec_helper'

describe CIBootstrap::SSHService do

  describe ".initialize" do
    it "stored the ssh config values" do
      @config_file = stub
      @ssh_config = stub.as_null_object
      Net::SSH.stub(:start)
      Net::SSH::Config.should_receive(:load).with(@config_file).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end

    it "stores the ssh config values" do
      @config_file = stub
      @ssh_config = {"user" => stub}
      Net::SSH.stub(:start)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
      @ssh_service.instance_variable_get(:@config).should == @ssh_config
    end

    it "builds a net ssh service" do
      @config_file = stub
      @user = stub
      @ssh_config = {"user" => @user}
      Net::SSH.should_receive(:start).with("default", @user, {:config => @config_file})
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end

    it "returns a new ssh service" do
      @config_file = stub
      @ssh_config = stub.as_null_object
      Net::SSH.stub(:start)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
      @ssh_service.should be_a(CIBootstrap::SSHService)
    end
  end

  describe "#run_remote_command" do
    before :each do
      @config_file = stub
      @ssh_config = stub.as_null_object
      @ssh_session = stub
      Net::SSH.stub(:start).and_return(@ssh_session)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end

    it "calls ssh exec with the command" do
      @command = stub
      @ssh_session.should_receive(:exec!).with(@command) 
      @ssh_service.run_remote_command(@command)      
    end
  end

  describe "#upload_file" do
    before :each do
      @config_file = stub
      @ssh_config = stub.as_null_object
      @ssh_session = stub
      Net::SSH.stub(:start).and_return(@ssh_session)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end
      
    it "calls scp upload with the paths provided" do
      @remote_path = stub
      @local_path = stub
      @scp = stub
      @scp.should_receive(:upload!).with(@local_path, @remote_path)
      @ssh_session.stub(:scp).and_return(@scp)
      @ssh_service.upload_file(@local_path, @remote_path)
    end
  end

  describe "#download_file" do
    before :each do
      @config_file = stub
      @ssh_config = stub.as_null_object
      @ssh_session = stub
      Net::SSH.stub(:start).and_return(@ssh_session)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end
      
    it "calls scp download with the paths provided" do
      @remote_path = stub
      @local_path = stub
      @scp = stub
      @scp.should_receive(:download!).with(@remote_path, @local_path)
      @ssh_session.stub(:scp).and_return(@scp)
      @ssh_service.download_file(@remote_path, @local_path)
    end
  end

  describe "#download_folder" do
    before :each do
      @config_file = stub
      @ssh_config = stub.as_null_object
      @ssh_session = stub
      Net::SSH.stub(:start).and_return(@ssh_session)
      Net::SSH::Config.stub(:load).and_return(@ssh_config)
      @ssh_service = CIBootstrap::SSHService.new(@config_file)
    end
      
    it "calls scp download recursive with the paths provided" do
      @remote_path = stub
      @local_path = stub
      @scp = stub
      @scp.should_receive(:download!).with(@remote_path, @local_path, {:recursive => true})
      @ssh_session.stub(:scp).and_return(@scp)
      @ssh_service.download_folder(@remote_path, @local_path)
    end
  end
end
