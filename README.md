# Shanty: a shack for your Vagrant

Shanty makes standardizing and interacting with your development environment
and continuous integration environment as easy as possible.

It does this by focusing implementing standards around the use of 
[Vagrant](http://www.vagrantup.com/) for managing your development environment
and continuous integration environment. This means that it helps you
config and setup [Vagrant](http://www.vagrantup.com/), generate well
structured initial puppet manifests to get you off and iterating, and handle
spinning up your continuous integration & run the tests locally or in the
cloud via aws or openstack.

## Installation

Install it by running the following:

    $ gem install shanty

## Set up your project

Setting a new or existing project up with Shanty is done with the following
steps.

1. Setup initial Shanty configs & skeletons
2. Update the generated configs
3. Build your base Shanty
4. Iterate on your Shanty
5. Run your Test Suite using Shanty

### Setup initial Shanty configs & skeletons

To *shantify* your project you need to run the `shanty init <language>` command.
This command will create an initial `.shanty.yml` config for you in the
current working directory. Therefore, you should run this command from the
root of your project. It will also handle creating your user level shanty
configurations in the `~/.shanty` direcotry. An example of this can be seen as
follows:

    $ shanty init ruby

*Note:* The above will create user level configs using the default provider
`virtualbox`. If you want to use shanty with a cloud provider simply rerun the
init command specifying one of the supported providers. The following is an
example:

    $ shanty init -p openstack ruby

This will go through and setup the proper directory stucture and create the
config files just as before. However, when it identifies conflicts with the
existing files it will prompt you and ask you if you want to overwrite, diff
the files, not overwrite, etc.

This means that you can rerun the command over and over again and not worry
about it overwriting your configs unless it tells you too. This is also useful
in the scenarios where a new version of shanty has come out and added config
options because then you can rerun it and choose to diff them to see what was
added.

### Update the generated configs

Now that the initial configs and skeleton have been generated. We need to go
through the configs and update them.

### Build your base Shanty

### Iterate on your Shanty

### Run your Test Suite using Shanty

Bring up the shanty with your cloud provider, run the tests, and shutdown the
cloud node.

    $ cd project_dir
    $ shanty test

To see more output on what is happening, pass the "-v" flag:

    $ shanty test -v

## Get Help

Shanty provides a useful help system within the command line tool. You can see
these messages by using the help command as follows:

    $ shanty help

The above shows you the top level shanty help including a break down of it's
subcommands. You can get detailed help on each subcommand by running the
following:

    $ shanty help SUBCOMMAND

For example if you wanted the detailed help on `init` you would run the
following:

    $ shanty help init

## Config Breakdown

### .shanty.yml

After initializing, you need to configure the `.shanty.yml` in the root of your
project.

See the generated `shanty.yml` file for help with configuration.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/shanty/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
