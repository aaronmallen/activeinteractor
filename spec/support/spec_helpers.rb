# frozen_string_literal: true

Dir[File.join(__dir__, 'helpers', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Spec::Helpers::Factories
end
