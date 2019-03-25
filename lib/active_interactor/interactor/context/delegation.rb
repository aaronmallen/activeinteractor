# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      module Delegation
        extend ActiveSupport::Concern

        included do
          delegate(*ActiveModel::Validations.instance_methods, to: :context, prefix: true)
          delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context, prefix: true)

          class << self
            delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :context_class, prefix: :context)
            delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context_class, prefix: :context)
          end
        end
      end
    end
  end
end
