# Boxci: a shack for your Vagrant

Boxci makes standardizing and interacting with your development environment
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

    $ gem install boxci

## Set up your project

Setting a new or existing project up with Boxci is done with the following
steps.

1. Setup initial Boxci configs & skeletons
2. Update the generated configs
3. Build your base Boxci
4. Iterate on your Boxci
5. Run your Test Suite using Boxci

### Setup initial Boxci configs & skeletons

To *shantify* your project you need to run the `boxci init <language>` command.
This command will create an initial `.boxci.yml` config for you in the
current working directory. Therefore, you should run this command from the
root of your project. It will also handle creating your user level boxci
configurations in the `~/.boxci` direcotry. An example of this can be seen as
follows:

    $ boxci init ruby

*Note:* The above will create user level configs using the default provider
`virtualbox`. If you want to use boxci with a cloud provider simply rerun the
init command specifying one of the supported providers. The following is an
example:

    $ boxci init -p openstack ruby

This will go through and setup the proper directory stucture and create the
config files just as before. However, when it identifies conflicts with the
existing files it will prompt you and ask you if you want to overwrite, diff
the files, not overwrite, etc.

This means that you can rerun the command over and over again and not worry
about it overwriting your configs unless it tells you too. This is also useful
in the scenarios where a new version of boxci has come out and added config
options because then you can rerun it and choose to diff them to see what was
added.

### Update the generated configs

Now that the initial configs and skeleton have been generated. We need to go
through the configs and update them.

### Build your base Boxci

### Iterate on your Boxci

### Run your Test Suite using Boxci

Bring up the boxci with your cloud provider, run the tests, and shutdown the
cloud node.

    $ cd project_dir
    $ boxci test

To see more output on what is happening, pass the "-v" flag:

    $ boxci test -v

## Get Help

Boxci provides a useful help system within the command line tool. You can see
these messages by using the help command as follows:

    $ boxci help

The above shows you the top level boxci help including a break down of it's
subcommands. You can get detailed help on each subcommand by running the
following:

    $ boxci help SUBCOMMAND

For example if you wanted the detailed help on `init` you would run the
following:

    $ boxci help init

## Config Breakdown

### .boxci.yml

After initializing, you need to configure the `.boxci.yml` in the root of your
project.

See the generated `boxci.yml` file for help with configuration.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/boxci/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
