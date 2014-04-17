[![Build Status](https://travis-ci.org/reachlocal/boxci.svg?branch=master)](https://travis-ci.org/reachlocal/boxci)
[![Version](https://img.shields.io/gem/v/boxci.svg)](https://rubygems.org/gems/boxci)
[![Code Climate](https://img.shields.io/codeclimate/github/reachlocal/boxci.svg)](https://codeclimate.com/github/reachlocal/boxci)
[![Code Coverage](http://img.shields.io/coveralls/reachlocal/boxci.svg)](https://coveralls.io/r/reachlocal/boxci)
[![Dependency Status](https://gemnasium.com/reachlocal/boxci.svg)](https://gemnasium.com/reachlocal/boxci)

# BoxCI: virtual dev & ci environments

BoxCI makes creating a virtualized development & continuous integration
environments as easy as possible.

It does this by implementing standards around the use of
[Vagrant](http://www.vagrantup.com/) for managing your virtual development and
continuous integration environment. This means that it helps you configure and
setup [Vagrant](http://www.vagrantup.com/), generate a well structured initial
puppet manifest, and handles spinning up your puppet managed continuous
integration environment in the cloud and running your automated test
suites.

## Installation and usage

Install it by running the following:

    gem install boxci
    boxci init ruby
    boxci build
    boxci test

## Documentation

See [boxci.io](http://boxci.io) for the full documentation.

## Troubleshooting

For help with common problems, see
[ISSUES](http://github.com/reachlocal/boxci/blob/master/ISSUES.md).

## Contributing

If you would like to contribute to BoxCI, please refer to the guide,
[DEVELOPMENT](http://github.com/reachlocal/boxci/blob/master/DEVELOPMENT.md).

Please submit bugfixes as pull requests to the master branch.

## Core Team

The BoxCI core team is composed of Andrew De Ponte
([@cyphactor](http://github.com/cyphactor)), Brian Miller
([@BRIMIL01](http://github.com/brimil01)), and Russell Cloak
([@russCloak](http://github.com/russCloak)).

## Other questions

To see what has changed in recent versions of BoxCI, see
[CHANGELOG](http://github.com/reachlocal/boxci/blob/master/CHANGELOG.md).

Feel free to chat with the BoxCI core team and others on IRC in the
[\#boxci](irc://chat.freenode.net/%23boxci) channel on Freenode, or via e-mail
on the [BoxCI mailing list](https://groups.google.com/forum/#!forum/boxci).
