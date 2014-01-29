# Shanty

Shanty is a project focused on providing standards around the use of
[Vagrant](http://www.vagrantup.com/) to make managing
[Vagrant](http://www.vagrantup.com/) based development environments and
continuous integration environments easy.

## Installation

Add this line to your application's Gemfile:

    gem 'shanty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shanty

### First Run

All commands check for dependencies at beginning of launch and short circuit
with helpful message.

Check for cloud_provider_config every run and notify if is missing with
helpful message.


    $ gem install shanty

    $ cd project_dir
    $ shanty init

    Hey you don't have you clouder provider config please generate the example
    and populate it with proper values and then re-run whatever command was
    halted.
    $ shanty generate cloud_provider_config

    $ cd project_dir
    $ shanty init

    Show which files were generate and say finished. Note: Files should have
    useful comments inside of them for things users would likely want to
    change.

### Running Tests

    $ cd project_dir
    $ shanty test

### Running Dev Environment

    $ cd project_dir
    $ shanty build

### Tear Down Dev Environment

    $ shanty destroy

## Usage

### init

Initialize the specified directory as a shanty. 

    $ shanty init .

The above command creates the initial shanty skeleton in a project if it is
not already a shanty. This will create the following files in the specified
directory: `Vagrantfile`, `puppet/manifests`, `puppet/manifests/main.pp`,
`puppet/modules`, `puppet/modules/.gitkeep`, `.shanty.yml`

### generate provider_config

Generate the example `~/.shanty/cloud_provider_config.yml` with the following command.

    $ shanty generate provider_config

### test

Bring up the shanty with your cloud provider, run the tests, and shutdown the
cloud node.

    $ shanty test

## Contributing

1. Fork it ( http://github.com/<my-github-username>/shanty/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
