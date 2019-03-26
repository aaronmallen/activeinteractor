# frozen_string_literal: true

module ActiveInteractor
  # Loads all dependencies for {ActiveInteractor::Context}
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Interactor
    extend ActiveSupport::Autoload

    autoload :Action
    autoload :Callbacks
    autoload :Context
    autoload :Core
  end
end
