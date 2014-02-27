module Shanty
  class CLI < Thor
    include Thor::Actions
    
    DEFAULT_PROVIDER='virtualbox'
    DEFAULT_REVISION='HEAD'

    desc "init LANGUAGE [PROVIDER]", "Initializes Shanty in the present working directory"
    long_desc <<-LONGDESC
      `shanty init LANGUAGE [PROVIDER]` will create a .shanty directory in
      your user's home directory, create a provider specific config (ex:
      ~/.shanty/providers/virtualbox.yml), set the default provider in
      (~/.shanty/provider_config.yml), and create a project config (.shanty.yml)
      in the current working directory.

      LANGUAGE is required, it is the language of your project, see supported
      languages below.

      PROVIDER is optional, and if omitted will default to '#{DEFAULT_PROVIDER}'.

      Supported Languages: #{Shanty::Language.supported_languages.join(", ")}
      \005Supported Providers: #{Shanty::Provider.supported_providers.join(", ")}
    LONGDESC
    def init(language, provider=DEFAULT_PROVIDER)
      initializer = Shanty::Initializer.new
      initializer.init(language, provider)
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
      puts "DREW: waeuaoeuaoeuaoeuaoeuaoeuaoeuaoeuaoeueoauoeaaoeuaoeuaoe"
      # tester = Shanty::Tester.new
      # tester.test(options.merge({"revision" => revision}))
    end
  end
end
