# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem 'mdl'
  gem 'rails'
  gem 'rubocop'
  # Note: simplecov version regressed from 0.18.1 to 0.17.1 until fix:
  # https://github.com/codacy/ruby-codacy-coverage/issues/50
  gem 'simplecov', '0.18.5'
  gem 'solargraph'
end

group :doc do
  gem 'github-markup'
  gem 'redcarpet'
  gem 'yard'
end

# Specify your gem's dependencies in activeinteractor.gemspec
gemspec
