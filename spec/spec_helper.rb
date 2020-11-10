# frozen_string_literal: true

begin
  require 'simplecov'
  require 'simplecov-lcov'

  SimpleCov::Formatter::LcovFormatter.config do |config|
    config.report_with_single_file = true
    config.single_report_path = 'coverage/lcov.info'
  end

  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
    track_files '/lib/**/*.rb'
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::HTMLFormatter,
                                                         SimpleCov::Formatter::LcovFormatter
                                                       ])
  end
rescue LoadError
  puts 'Skipping coverage...'
end

require 'bundler/setup'
require 'active_interactor'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = 'spec/.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }
