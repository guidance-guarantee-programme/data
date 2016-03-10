require_relative './config/application'

Rails.application.load_tasks

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
end

task default: %i(spec cucumber rubocop)
