# frozen_string_literal: true

require 'active_interactor'
require 'active_interactor/rails'

module ActiveInteractor
  class Railtie < ::Rails::Railtie
    config.active_interactor = ActiveInteractor.config

    initializer 'active_interactor.autoload_paths', after: :load_config_initializers do
      config.after_initialize do |app|
        app.config.autoload_paths += ["app/#{ActiveInteractor.config.rails.directory}"]
      end
    end
  end
end
