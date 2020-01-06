# frozen_string_literal: true

require 'rails'

module ActiveInteractor
  class Railtie < ::Rails::Railtie
    config.active_interactor = ActiveInteractor.config
  end
end
