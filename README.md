# CiBootstrap

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'ci_bootstrap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ci_bootstrap

## Usage and config

    $ ci_bootstrap <ci workspace path> <repository revision>

An example of this with bamboo might look as follows:

    $ ci_bootstrap ${bamboo.build.working.directory} ${bamboo.repository.revision.number}

However, if you want to test it manually you can always run it as follows:

    $ ci_bootstrap <path to local git repo>

NOTE: this will change once the gem has been created
  
1. ssh to the build agent machine
1. cd to home dir
1. create an /opt/ci_bootstrap folder
     sudo mkdir /opt/ci_bootstrap
1. give the ubuntu user read/write/execute permissions on the folder
       sudo chown -R ubuntu:ubuntu /opt/ci_bootstrap
1. cd to the /opt folder
1. checkout the [ci bootstrap](https://stash.lax.reachlocal.com/projects/CAP/repos/ci_bootstrap/browse) project into /opt to install it.
       git clone ssh://git@stash.lax.reachlocal.com/cap/ci_bootstrap.git <!--ssh://git@stash.lax.reachlocal.com/~robert.tomb/ci_bootstrap.git-->
1. cd into /opt/ci_bootstrap
1. follow prompts to install the right version of ruby with rvm                                                                       
1. cd .
1. install bundler `gem install bundler`
1. install gems needed for ci_bootstrap `bundle install`
1. create /opt/ci_bootstrap/provider_config.yml

```text
openstack:
  username: your.name                                                                                                             
  api_key: PassphrasesCanBeLongAsWellAsSh0rt
  private_key_path: "~/.ssh/id_dsa"
  key_pair: yourname
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## CI Bootstrap Overview

I am still in the process of rewriting the bootstrap script into something more modular, tested and maintainable but the general idea is a easily configurable CI bootstrap runner that creates a vagrantfile and test runner for CI jobs. To get a project set up you will need a manifest to configure your vagrant box and the modules it uses in your project. I recommend just using the same manifest you have for your dev vagrant box. It is also recommended to add the ci_runner gem to your Gemfile under tests since the test results need to be the JUnit xml format for jenkins and bamboo to understand them.

In order for the ci_bootstrap running to set up your vagrant box a configuration file should be added at the project root. The capture_api one looks like this:

```text
provider: aws
type: ruby
project_name: capture_api
project_manifest: capture_api.pp
puppet_folder: puppet
project_setup: |
  bundle exec rake cequel:create
  bundle exec rake cequel:migrate
tests_to_run: |
  bundle exec ruby -r ci/reporter/rake/cucumber_loader -S cucumber --format CI::Reporter::Cucumber
  bundle exec rspec --require ci/reporter/rake/rspec_loader --format CI::Reporter::RSpec spec
  RUNNER=`ruby -e "puts File.expand_path(ARGV.shift)" capture_js/tests/jasmine/JUnitRunner.html`
  phantomjs capture_js/tests/jasmine/lib/phantomjs-testrunner.js $RUNNER
```

Currently the only provider we support is aws. It is assumed that your manifest is in your puppet_folder and all modules are available under puppet_folder/modules. The project_setup commands are run after ruby and bundled gems have been installed and should be to set up any app requirements prior to the test suite run. The tests_to_run configuration are the actual test commands that will be run.

To set up the CI to run the following shell commands are needed for the build:
  cd /opt/ci_boostrap # or wherever ci_bootstrap is installed
  ./ci_boostrap.rb $WORKSPACE $GIT_COMMIT
The xml results will be put into the reports directory in the project. You will want to configure jenkins or bamboo to look in that folder for JUnit test results.

The bootstrap process does the following:

1. Creates a working directory to run the vagrant box in
2. Creates an archive of the current branch to be tested
3. Writes out a Vagrantfile based upon the configuration values provided in the ci_bootstrap.yml
4. Spins up an AWS instance to run tests on and runs puppet configurations on the instance
5. Sets up ruby, gems, and runs project_setup commands
6. Runs tests and collects results

This is a rewrite of the current process that is being used on Jenkins and should provide a lot more flexibility with configuration and management. So next steps are:

1. Finish capture_api updates to vagrant and get them merged
2. Finish writing the ci_bootstrap and get it set up for jenkins and bamboo.
3. Configure Bamboo so it will run vagrant based jobs

Let me know if you have any questions or suggestions.
