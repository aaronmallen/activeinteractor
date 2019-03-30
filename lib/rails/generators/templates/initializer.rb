# frozen_string_literal: true

require 'active_interactor'

ActiveInteractor.configure do |config|
  # Set the ActiveInteractor.logger to Rails.logger
  config.logger = Rails.logger
end
