# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      # Delegates all ActiveModel::Validation methods to the interactor context
      #
      # @api private
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.0.1
      # @version 0.1
      #
      # @see https://api.rubyonrails.org/classes/ActiveModel/Validations.html
      #  ActiveModel::Validations
      # @see https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html
      #  ActiveModel::Validations::ClassMethods
      # @see https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html
      #  ActiveModel::Validations::HelperMethods
      #
      # @note all validation methods are prefixed with `context_` so
      #  for example `validates` becomes `context_validates`
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
