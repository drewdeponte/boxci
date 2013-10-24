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
     openstack:
       username: your.name                                                                                                             
       api_key: PassphrasesCanBeLongAsWellAsSh0rt
       private_key_path: "~/.ssh/id_dsa"
       key_pair: yourname

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
