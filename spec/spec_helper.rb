# frozen_string_literal: true

require_relative 'support/coverage'
ActiveInteractor::Spec::Coverage.start

require 'bundler/setup'
require 'active_interactor'
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include ActiveInteractor::Spec::Helpers::FactoryMethods

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = 'spec/.rspec_status'

  config.after do
    ActiveInteractor::Spec::FactoryCollection.clean!
  end

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end
