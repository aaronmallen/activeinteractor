# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec)

begin
  require 'rubocop/rake_task'
  require 'yard'

  RuboCop::RakeTask.new do |task|
    task.options << '-D'
  end

  task :mdl do
    puts 'Running Markdown Lint...'
    system 'mdl *.md' || exit(-1)
  end

  YARD::Rake::YardocTask.new(:doc)
  Rake::Task[:spec].clear.enhance %i[mdl rubocop rspec]
rescue LoadError
  Rake::Task[:spec].clear.enhance %i[rspec]
end

task default: %i[spec build]
