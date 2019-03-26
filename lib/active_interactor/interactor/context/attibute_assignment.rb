# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      # Provides context attribute assignment methods to included classes
      #
      # @api private
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.0.1
      # @version 0.1
      module AttributeAssignment
        extend ActiveSupport::Concern

        class_methods do
          # Assign attributes to the context class of the interactor
          #
          # @example Assign attributes to the context class
          #  class MyInteractor > ActiveInteractor::Base
          #    context_attributes :first_name, :last_name
          #  end
          #
          #  MyInteractor::Context.attributes
          #  #=> [:first_name, :last_name]
          # @param attributes [Array] the attributes to assign to the context
          def context_attributes(*attributes)
            context_class.attributes = attributes
          end
        end
      end
    end
  end
end
