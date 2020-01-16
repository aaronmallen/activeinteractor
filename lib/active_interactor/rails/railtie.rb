# frozen_string_literal: true

require 'rails'

require 'active_interactor'

module ActiveInteractor
  module Rails
    # Configure ActiveInteractor for rails
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    class Railtie < ::Rails::Railtie
      config.active_interactor = ActiveInteractor::Rails.config

      config.eager_load_namespaces << ActiveInteractor

      config.to_prepare do
        ActiveInteractor.configure do |c|
          c.logger = ::Rails.logger
        end
      end
    end
  end
end
