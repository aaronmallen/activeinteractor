# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem 'bundler', '~> 2.2'
  gem 'code-scanning-rubocop'
  gem 'mdl', '~> 0.11'
  gem 'rails'
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.10'
  gem 'rubocop', '~> 1.12'
  gem 'rubocop-performance', '~> 1.10'
  gem 'rubocop-rspec', '~> 2.2'
end

group :test do
  gem 'simplecov', '~> 0.21'
  gem 'simplecov-lcov', '~> 0.8'
end

group :doc do
  gem 'github-markup'
  gem 'redcarpet'
  gem 'yard'
end

# Specify your gem's dependencies in activeinteractor.gemspec
gemspec
