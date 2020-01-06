# frozen_string_literal: true

begin
  require 'codacy-coverage'
  require 'simplecov'

  Codacy::Reporter.start if ENV['CODACY_PROJECT_TOKEN']
  SimpleCov.start do
    track_files '/lib/**/*.rb'
    add_filter '/spec/'
    add_filter '/lib/rails/**'
  end
rescue LoadError
  puts 'Not reporting coverage...'
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
