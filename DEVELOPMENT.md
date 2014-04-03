Great to have you here! Here are a few ways you can help out with
[BoxCI](http://github.com/reachlocal/boxci).

# Where should I start?

You can start learning about BoxCI by reading [the
documentation](http://boxci.io).  You can also check out discussions about
BoxCI on the [BoxCI mailing
list](https://groups.google.com/forum/#!forum/boxci) and in the [BoxCI IRC
channel](irc://chat.freenode.net/%23boxci), which is #boxci on Freenode.

## Your first commits

If you’re interested in contributing to BoxCI, that’s awesome! We’d love your
help.

If you have any questions after reading this page, please feel free to contact
either [@cyphactor](http://github.com/cyphactor) or
[@hone](http://github.com/brimil01). They are both happy to provide help
working through your first bugfix or thinking through the problem you’re
trying to resolve.

## Tackle some small problems

We track [small
bugs](https://github.com/reachlocal/boxci/issues?labels=small&state=open) so
that anyone who wants to help can start with something that's not too
overwhelming. If nothing on those lists looks good, though, just talk to us.


# Development setup

BoxCI specifies the version of Ruby it is currently being developed against in
its `.ruby-version` file. This file should be compatible with either RVM or
rbenv. BoxCI also uses Bundler to manage its dependencies when under
development. To work on BoxCI, you'll probably want to do a couple of things.

1. Install BoxCI's dependencies

        bundle

2. Run the test suite, to make sure things are working

        bundle exec rspec

3. Set up a shell alias to run BoxCI from your clone, e.g. a Bash alias:

        alias dboxci='ruby -I /path/to/boxci/lib /path/to/boxci/bin/boxci'

With that set up, you can test changes you've made to BoxCI by running
`dboxci`, without interfering with the regular `boxci` command.

# Bug triage

Triage is the work of processing tickets that have been opened into actionable
issues, feature requests, or bug reports. That includes verifying bugs,
categorizing the ticket, and ensuring there's enough information to reproduce
the bug for anyone who wants to try to fix it.

We've created an [issues
guide](https://github.com/reachlocal/boxci/blob/master/ISSUES.md) to walk
BoxCI users through the process of troubleshooting issues and reporting
bugs.

If you'd like to help, awesome! You can [report a new
bug](https://github.com/reachlocal/boxci/issues/new) or browse our [existing
open tickets](https://github.com/reachlocal/boxci/issues).

Not every ticket will point to a bug in BoxCI's code, but open tickets
usually mean that there is something we could improve to help that user.
Sometimes that means writing additional documentation, sometimes that means
making error messages clearer, and sometimes that means explaining to a user
that they need to install git to use git gems.

When you're looking at a ticket, here are the main questions to ask:

  * Can I reproduce this bug myself?
  * Are the steps to reproduce clearly stated in the ticket?
  * Which versions of BoxCI manifest this bug?
  * Which operating systems (OS X, Windows, Ubuntu, CentOS, etc.) manifest
    this bug?
  * Which rubies (MRI, JRuby, Rubinius, etc.) and which versions (1.8.7,
    1.9.3, etc.) have this bug?

If you can't reproduce an issue, chances are good that the bug has been fixed
(hurrah!). That's a good time to post to the ticket explaining what you did
and how it worked.

If you can reproduce an issue, you're well on your way to fixing it. :) Fixing
issues is similar to adding new features:

  1. Discuss the fix on the existing issue. Coordinating with everyone else
     saves duplicate work and serves as a great way to get suggestions and
     ideas if you need any.
  2. Base your commits on the correct branch, generally master.
  3. Commit the code and at least one test covering your changes to a named
     branch in your fork.
  4. Put a line in the
     [CHANGELOG](https://github.com/reachlocal/boxci/blob/master/CHANGELOG.md)
     summarizing your changes under the next release.
  5. Send us a [pull
     request](https://help.github.com/articles/using-pull-requests) from your
     topic branch.

Finally, the ticket may be a duplicate of another older ticket. If you notice
a ticket is a duplicate, simply comment on the ticket noting the original
ticket’s number. For example, you could say “This is a duplicate of issue #42,
and can be closed”.


# Adding new features

If you would like to add a new feature to BoxCI, please follow these steps:

  1. [Create an issue](https://github.com/reachlocal/boxci/issues/new) to
     discuss your feature.
  2. Base your commits on the master branch, since we follow
     [SemVer](http://semver.org) and don't add new features to old releases.
  3. Commit the code and at least one test covering your changes to a feature
     branch in your fork.
  4. Put a line in the
     [CHANGELOG](https://github.com/reachlocal/boxci/blob/master/CHANGELOG.md)
     summarizing your changes under the next release.
  5. Send us a [pull
     request](https://help.github.com/articles/using-pull-requests) from your
     feature branch.

If you don't hear back immediately, don’t get discouraged! We all have day
jobs, but we respond to most tickets within a day or two.


# Beta testing

Early releases require heavy testing, especially across various system setups.
We :heart: testers, and are big fans of anyone who can run `gem install
bundler --pre` and try out upcoming releases in their development and staging
environments.

There may not always be prereleases or beta versions of BoxCI. That said,
you are always welcome to try checking out master and building a gem yourself
if you want to try out the latest changes.


# Translations

We don't currently have any translations, but please reach out to us if you
would like to help get this going.


# Documentation

Code needs explanation, and sometimes those who know the code well have
trouble explaining it to someone just getting into it. Because of that, we
welcome documentation suggestions and patches from everyone, especially if
they are brand new to using BoxCI.

BoxCI has two main sources of documentation: the built-in help (including
usage information) and the [BoxCI documentation site](http://boxci.io).

If you have a suggestion or proposed change for
[boxci.io](http://boxci.io), please open an issue or send a pull request
to the [boxci-site](https://github.com/reachlocal/boxci-site) repository.



# Community

Community is an important part of all we do. If you’d like to be part of the
BoxCI community, you can jump right in and start helping make BoxCI better
for everyone who uses it.

It would be tremendously helpful to have more people answering questions about
BoxCI (and often simply about Puppet or Linux itself) in our [issue
tracker](https://github.com/reachlocal/boxci/issues).

Additional documentation and explanation is always helpful, too. If you have
any suggestions for the BoxCI website [boxci.io](http://boxci.io), we would
absolutely love it if you opened an issue or pull request on the
[boxci-site](https://github.com/reachlocal/boxci-site) repository.

Finally, sharing your experiences and discoveries by writing them up is a
valuable way to help others who have similar problems or experiences in the
future. You can write a blog post, create an example and commit it to Github,
take screenshots, or make videos.

Examples of how BoxCI is used help everyone, and we’ve discovered that
people already use it in ways that we never imagined when we were writing it.
If you’re still not sure what to write about, there are also several projects
doing interesting things based on BoxCI. They could probably use publicity
too.

If you let someone on the core team know you wrote about BoxCI, we will add
your post to the list of BoxCI resources on the Github project wiki.
