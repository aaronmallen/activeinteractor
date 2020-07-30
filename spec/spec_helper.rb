# frozen_string_literal: true

begin
  require 'simplecov'
  require 'simplecov-lcov'

  SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
    add_filter '/lib/rails/**/*.rb'
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

  config.before do
    # suppress logs in test
    allow(ActiveInteractor.logger).to receive(:error).and_return(true)
  end

  config.after(:each) do
    clean_factories!
  end

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }
