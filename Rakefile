require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Cucumber::Rake::Task.new(:features)
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i(spec features rubocop)
