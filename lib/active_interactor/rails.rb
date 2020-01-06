# frozen_string_literal: true

module ActiveInteractor
  # Rails specific classes, helpers, and utlities
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  module Rails
    extend ActiveSupport::Autoload

    autoload :Config
  end
end
