# frozen_string_literal: true

require 'rails'

module ActiveInteractor
  # Rails classes and modules.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  module Rails
    # The ActiveInteractor Railtie
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    #
    # @see https://api.rubyonrails.org/classes/Rails/Railtie.html
    class Railtie < ::Rails::Railtie
      config.eager_load_namespaces << ActiveInteractor
    end
  end
end
