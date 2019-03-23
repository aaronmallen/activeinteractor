# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.options << '-D'
end

task :mdl do
  puts 'Running Markdown Lint...'
  system 'mdl *.md' || exit(-1)
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.stats_options = ['--list-undoc']
end

task default: %i[mdl rubocop spec doc]
