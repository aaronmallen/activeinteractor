# frozen_string_literal: true

require 'active_interactor'
require 'active_interactor/rails'

module ActiveInteractor
  class Railtie < ::Rails::Railtie
    config.active_interactor = ActiveInteractor.config

    intializer 'active_interactor.add_watchable_dirs', after: :load_config_initializers do
      config.watchable_dirs["app/#{ActiveInteractor.config.rails.directory}"] = ['.rb']
    end
  end
end
