require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

# Add a simple console for debugging.
#
# Start it with:
# bundle exec rake console
task :console do
  require 'irb'
  require 'irb/completion'
  require 'shanty'
  ARGV.clear
  IRB.start
end

task :default => :spec
