# frozen_string_literal: true

require 'active_interactor'

ActiveInteractor.configure do |config|
  # Set the ActiveInteractor.logger to Rails.logger
  config.logger = Rails.logger

  # Set the default directory for interactors
  # NOTE: if this is changed after `active_interactor:install`
  # is generated you will need to update
  # config/application.rb autoload paths with the
  # new directory name.
  # config.dir_name = 'interactors'
end
