# Shanty

Shanty is a project focused on providing standards around the use of
[Vagrant](http://www.vagrantup.com/) to make managing
[Vagrant](http://www.vagrantup.com/) based development environments and
continuous integration environments easy.

## Installation

Install it by running the following:

    $ gem install shanty

## Setup

To *shantify* your project you need to run the `shanty init <language>` command.
This command will create an initial `.shanty.yml` config for you in the
current working directory. Therefore, you should run this command from the
root of your project. It will also handle creating your user level shanty
configurations in the `~/.shanty` direcotry. An example of this can be seen as
follows:

    $ cd project_dir
    $ shanty init ruby

### cloud_provider_config.yml

If you don't already have a `cloud_provider_config.yml` in your `~/.shanty`
directory, you'll need to generate one with:

    $ shanty generate cloud_provider_config

This will create an example `cloud_provider_config.yml` in the `~/.shanty`
directory for you. Next, edit it using the following guide:

#### Openstack

For Openstack, the structure should be:

    openstack:
      username: rl.user
      password: rl.password
      private_key_path: "~/.ssh/id_rsa"
      key_pair: rl.keypair

The individual fields are explained below.

##### username

This is your username for opensource. It is also sometimes referred to as the
"tenant name".

##### password

This is your password for interacting with opensource. If you've setup any of
the command-line clients such as "Nova", this was set during your initial
system setup. It is also sometimes referred to as the "api_key".

##### private_key_path

This one is pretty straight forward, it's the path to your public key used to
authenticate for Openstack.

##### key_pair

This is often the same as your `username`, but can sometimes be different. If
you are using the "Nova" command-line tool, you can see what your `key_pair`
value is by running:

    $ nova keypair-list

You should see output similar to:

    +--------+-------------------------------------------------+
    | Name   | Fingerprint                                     |
    +--------+-------------------------------------------------+
    | jsmith | 0a:1c:2b:3d:1c:2b:3d:1c:2b:3d:1c:2b:3d:1c:2b:3d |
    +--------+-------------------------------------------------+

Given this output, your `key_pair` value is `jsmith`.

### .shanty.yml

After initializing, you need to configure the `.shanty.yml` in the root of your
project.

See the generated `shanty.yml` file for help with configuration.

## Usage

### Running Tests

Bring up the shanty with your cloud provider, run the tests, and shutdown the
cloud node.

    $ cd project_dir
    $ shanty test

To see more output on what is happening, pass the "-v" flag:

    $ shanty test -v

## Contributing

1. Fork it ( http://github.com/<my-github-username>/shanty/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
