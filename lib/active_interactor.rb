# frozen_string_literal: true

require 'active_model'

require 'active_interactor/version'

module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Configuration
  autoload :Context
  autoload :Interactor

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def logger
      configuration.logger
    end
  end
end
