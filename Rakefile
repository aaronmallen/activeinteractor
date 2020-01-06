# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec)

begin
  require 'mdl'
  require 'rubocop/rake_task'
  require 'yard'

  RuboCop::RakeTask.new do |task|
    task.options << '-D'
  end

  task :mdl do
    puts 'Linting markdown documents...'
    MarkdownLint.run(Dir['*.md'])
  # MarkdownLint#run calls system exit regardless of status.
  rescue SystemExit # rubocop:disable Lint/SuppressedException
  end

  YARD::Rake::YardocTask.new(:doc) do |t|
    t.stats_options = ['--list-undoc']
  end

  Rake::Task[:spec].clear.enhance %i[mdl rubocop rspec]
  task default: %i[spec doc build]
rescue LoadError
  Rake::Task[:spec].clear.enhance %i[rspec]
  task default: %i[spec build]
end
