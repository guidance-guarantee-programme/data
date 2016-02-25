require_relative './config/application'

require 'cucumber/rake/task'
require 'rubocop/rake_task'

Rails.application.load_tasks

Cucumber::Rake::Task.new
RuboCop::RakeTask.new

task default: %i(cucumber rubocop)
