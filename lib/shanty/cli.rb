module Shanty
  class CLI < Thor
    include Thor::Actions
    
    DEFAULT_PROVIDER='aws'
    DEFAULT_REVISION='HEAD'

    desc "init <language> [PROVIDER]", "Initializes Shanty in the present working directory"
    long_desc <<-LONGDESC
      `shanty init <language> [PROVIDER]` will create a .shanty directory in
      your user's home directory, create a provider specific config (ex:
      ~/.shanty/providers/aws.yml), set the default provider in
      (~/.shanty/provider_config.yml), and create a project config (.shanty.yml)
      in the current working directory.

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

    desc "test [--verbose, -v] [REVISION] [PROVIDER]", "Spins up the Shanty, runs the tests, then destroys the Shanty"
    long_desc <<-LONGDESC
      `shanty test [--verbose, -v] [REVISION] [PROVIDER]` Will spin up a new VM
      using the specified PROVIDER and run the given test steps against the
      REVISION.

      REVISION is optional, and if omitted will default to '#{DEFAULT_REVISION}'.
      \005PROVIDER is optional, and if omitted will use your configured default
      provider. If you don't have deafult provider configured it will default to
      '#{DEFAULT_PROVIDER}'.

      Passing the option --verbose will output a lot of debugging information, as
      well as explain exactly which commands are being run.
    LONGDESC
    option :verbose, :type => :boolean, :aliases => "-v"
    def test(provider=DEFAULT_PROVIDER, revision=DEFAULT_REVISION)
      tester = Shanty::Tester.new
      tester.test(options.merge({"revision" => revision}))
    end
  end
end
