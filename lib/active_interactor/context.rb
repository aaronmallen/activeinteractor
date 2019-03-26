# frozen_string_literal: true

module ActiveInteractor
  # Loads all dependencies for {ActiveInteractor::Context}
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Context
    extend ActiveSupport::Autoload

    autoload :Action
    autoload :Attribute
    autoload :Base
    autoload :Status

    eager_autoload do
      autoload :Failure, 'context/error'
    end
  end
end
