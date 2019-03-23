# frozen_string_literal: true

require 'active_model'
require 'active_support'

require 'active_interactor/version'

# ActiveInteractor
# @author Aaron Allen <hello@aaronmallen.me>
# @since v0.0.1
# @version 0.1
module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Context
  autoload :Contexts
  autoload :Interactor

  eager_autoload do
    autoload :Failure, 'active_interactor/error'
  end
end
