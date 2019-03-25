# frozen_string_literal: true

module ActiveInteractor
  module Context
    extend ActiveSupport::Autoload

    autoload :Action
    autoload :Attribute
    autoload :Base
    autoload :Status
    autoload :Validation

    eager_autoload do
      autoload :Failure, 'context/error'
    end
  end
end
