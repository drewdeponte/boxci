# ChangeLog

The following are lists of the notable changes included with each release.
This is intended to help keep people informed about notable changes between
versions as well as provide a rough history.

#### Next Release

#### v0.0.30

- Renamed project from `shanty` to `boxci`
- Moved all `TODO.txt` items to GitHub Issues
- Corrected author emails in the gemspec

#### v0.0.29

- Made Initializer not inherit from Thor
- Made Bulder not inherit from Thor
- Made Tester not inherit from Thor

#### v0.0.28

- Remove vagrant debugging from test subcommand cleanup

#### v0.0.27

- Included stderr on test subcomand cleanup logging

#### v0.0.26

- Added logging to the test subcommand cleanup

#### v0.0.25

- Moved workspace cleanup dir rm out of workspace folder block

#### v0.0.24

- Hid output of cleanup commands

#### v0.0.23

- Set SIGPIPE handler to `SIG_IGN`

#### v0.0.22

- Cleaned up hackish logging a bit

#### v0.0.21

- Switched rescue exception handling to StandardError

#### v0.0.20

- Added better exception logging

#### v0.0.19

- Added Errno::EPIPE swallowing in SIGTERM handler

#### v0.0.18

- Added rescue handler for cleanup in SIGTERM handler

#### v0.0.17

- Added Errno::EPIPE exception swallowing

#### v0.0.16

- Added Tester globalish exception logging

#### v0.0.15

- Fix few issues with the hack logging from `v0.0.14`

#### v0.0.14

- Added hack logging to verify signal handling

#### v0.0.13

- Added SIGPIPE swallowing to handle CI servers that kill stdout & stderr on
  build stop.

#### v0.0.12

- Remove top level exception handler

#### v0.0.11

- Wrapped test subcommand with unhandled exception handler

#### v0.0.10

- Added `--version` option to shanty

#### v0.0.9

- Added SIGTINT handler to run cleanup in test subcommand
- Added SIGTERM handler to run cleanup in test subcommand

#### v0.0.8

- Reworked init subcommand's provider option to match test subcommand
- Made it default to empty global config if not found
- Remove all the puts debugging added in v0.0.5 for Bamboo
- Add rake version constraint to gemspec

#### v0.0.7

- Made exceptino handler re-raise so thor exits when an exception happens

#### v0.0.6

- Added exception reporting around the initial config load in tester

#### v0.0.5

- Added puts around everything to see what was happening in Bamboo

#### v0.0.4

- Replaced test subcommand with puts to verify in Bamboo

#### v0.0.3

- Added thor exit on failure

#### v0.0.2

- Fixed bug where openstack node names had underscores
- Added artifact gathering and downloading
- Added `box_size` option to the `.shanty.yml`
- Fixed multiple script hook calls bug
- Made vagrant destroy forced so it doesn't prompt the user
- Fixed cd'ing issue before untar of code
- Bubble up exit code from test suite
- Added new test runner generator
- Added basic config permutations handling for rbenv
- Made virtualbox the default provider
- Added virtualbox support so can test things locally

#### v0.0.1

- Initial release
