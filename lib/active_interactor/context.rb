# frozen_string_literal: true

module ActiveInteractor
  # ActiveInteractor::Context classes
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  module Context
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Loader
  end
end
