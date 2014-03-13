module Shanty
  class CLI < Thor
    include Thor::Actions
    
    DEFAULT_PROVIDER='virtualbox'
    DEFAULT_REVISION='HEAD'

    desc "init [-p PROVIDER] LANGUAGE", "Initializes Shanty in the present working directory"
    long_desc <<-LONGDESC
      `shanty init [-p PROVIDER] LANGUAGE` will create a .shanty directory in
      your user's home directory, create a provider specific config (ex:
      ~/.shanty/providers/virtualbox.yml), set the default provider in
      (~/.shanty/global_config.yml), and create a project config (.shanty.yml)
      in the current working directory.

      LANGUAGE is required, it is the language of your project, see supported
      languages below.

      --provider (-p) is optional. If omitted, it will use your configured
      default provider (#{Shanty.default_provider}). If you don't have a
      default provider configured it will default to '#{DEFAULT_PROVIDER}'.

      Supported Languages: #{Shanty::Language.supported_languages.join(", ")}
      \005Supported Providers: #{Shanty::Provider.supported_providers.join(", ")}
    LONGDESC
    option :provider, :type => :string, :aliases => "-p", :default => Shanty.default_provider
    def init(language)
      initializer = Shanty::Initializer.new
      initializer.init(language, options['provider'])
    end

    desc "build", "Generates Vagrantfile & starter Puppet manifest"
    long_desc <<-LONGDESC
      `shanty build` will interpret your project config (.shanty.yml) and create
      a starting Vagrantfile and puppet setup in the current working directory.
    LONGDESC
    def build
      builder = Shanty::Builder.new
      builder.build
    end

    desc "test [-v] [-p PROVIDER] [REVISION]", "Spins up the Shanty, runs the tests, then destroys the Shanty"
    long_desc <<-LONGDESC
      `shanty test [-v] [-p PROVIDER] [REVISION]` will spin up a new VM using
      the PROVIDER and run the given test steps against the REVISION.

      --verbose (or -v) is optional. If added, there will be much more output
      a lot of debugging information, as well as explain exactly which commands
      are being run.

      --provider (-p) is optional. If omitted, it will use your configured
      default provider (#{Shanty.default_provider}). If you don't have a
      default provider configured it will default to '#{DEFAULT_PROVIDER}'.

      REVISION is optional, and if omitted will default to '#{DEFAULT_REVISION}'.
    LONGDESC
    option :verbose, :type => :boolean, :aliases => "-v"
    option :provider, :type => :string, :aliases => "-p", :default => Shanty.default_provider
    def test(revision=DEFAULT_REVISION)
      begin
        tester = Shanty::Tester.new
        tester.test(options.merge({"revision" => revision}))
      rescue Exception => e
        puts e.class
        puts e.message
        puts e.backtrace.join("\n")
        raise e
      end
    end

    map "--version" => :version
    desc "--version", "Output the version of Shanty being executed"
    def version
      puts "v#{Shanty::VERSION}"
    end
  end
end
