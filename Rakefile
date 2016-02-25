require_relative './config/application'

require 'cucumber/rake/task'
# require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Rails.application.load_tasks

Cucumber::Rake::Task.new
# RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i(spec cucumber rubocop)
