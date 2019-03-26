# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:rspec)

RuboCop::RakeTask.new do |task|
  task.options << '-D'
end

task :mdl do
  puts 'Running Markdown Lint...'
  system 'mdl *.md' || exit(-1)
end

YARD::Rake::YardocTask.new(:doc)

task spec: %i[mdl rubocop rspec]
task default: %i[spec doc build]
