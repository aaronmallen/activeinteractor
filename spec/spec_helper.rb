# frozen_string_literal: true

begin
  require 'codacy-coverage'
  require 'simplecov'

  Codacy::Reporter.start
  SimpleCov.start do
    track_files 'lib/**/*.rb'
    add_filter 'lib/rails/generators'
    add_filter '/spec/'
  end
rescue LoadError
  puts 'Not reporting coverage...'
end

require 'bundler/setup'
require 'active_interactor'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }
