# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem 'code-scanning-rubocop'
  gem 'mdl'
  gem 'rails'
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.11'
  gem 'rubocop', '1.7.0'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'solargraph'
end

group :test do
  gem 'simplecov'
  gem 'simplecov-lcov'
end

group :doc do
  gem 'github-markup'
  gem 'redcarpet'
  gem 'yard'
end

# Specify your gem's dependencies in activeinteractor.gemspec
gemspec
