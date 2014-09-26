module Boxci
  class CLI < Thor
    include Thor::Actions
    
    DEFAULT_PROVIDER='virtualbox'
    DEFAULT_REVISION='HEAD'

    desc "init [-p PROVIDER] LANGUAGE", "Initializes boxci in the present working directory"
    long_desc <<-LONGDESC
      `boxci init [-p PROVIDER] LANGUAGE` will create a .boxci directory in
      your user's home directory, create a provider specific config (ex:
      ~/.boxci/providers/virtualbox.yml), set the default provider in
      (~/.boxci/global_config.yml), and create a project config (.boxci.yml)
      in the current working directory.

      LANGUAGE is required, it is the language of your project, see supported
      languages below.

      --provider (-p) is optional. If omitted, it will use your configured
      default provider (#{Boxci.default_provider}). If you don't have a
      default provider configured it will default to '#{DEFAULT_PROVIDER}'.

      Supported Languages: #{Boxci.supported_languages.join(", ")}
      \005Supported Providers: #{Boxci::Provider.supported_providers.join(", ")}
    LONGDESC
    option :provider, :type => :string, :aliases => "-p", :default => Boxci.default_provider
    def init(language)
      initializer = Boxci::Initializer.new
      initializer.init(language, options['provider'])
    end

    desc "build", "Generates Vagrantfile & starter Puppet manifest"
    long_desc <<-LONGDESC
      `boxci build` will interpret your project config (.boxci.yml) and create
      a starting Vagrantfile and puppet setup in the current working directory.
    LONGDESC
    def build
      builder = Boxci::Builder.new
      builder.build
    end

    desc "test [-v] [-p PROVIDER] [REVISION]", "Spins up the boxci, runs the tests, then destroys the boxci"
    long_desc <<-LONGDESC
      `boxci test [-v] [-p PROVIDER] [REVISION]` will spin up a new VM using
      the PROVIDER and run the given test steps against the REVISION.

      --verbose (or -v) is optional. If added, there will be much more output
      a lot of debugging information, as well as explain exactly which commands
      are being run.

      --provider (-p) is optional. If omitted, it will use your configured
      default provider (#{Boxci.default_provider}). If you don't have a
      default provider configured it will default to '#{DEFAULT_PROVIDER}'.

      REVISION is optional, and if omitted will default to '#{DEFAULT_REVISION}'.
    LONGDESC
    option :verbose, :type => :boolean, :aliases => "-v"
    option :provider, :type => :string, :aliases => "-p", :default => Boxci.default_provider
    def test(revision=DEFAULT_REVISION)
      tester = Boxci::Tester.new
      tester.test(options.merge({"revision" => revision}))
    end

    map "--version" => :version
    desc "--version", "Output the version of boxci being executed"
    def version
      puts "v#{Boxci::VERSION}"
    end
  end
end
