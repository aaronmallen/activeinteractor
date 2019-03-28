# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides ActiveInteractor::Interactor::Context methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Context
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        include Callbacks

        delegate(*ActiveModel::Validations.instance_methods, to: :context, prefix: true)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context, prefix: true)
      end

      module ClassMethods
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :context_class, prefix: :context)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context_class, prefix: :context)

        # Create the context class for inherited classes.
        def inherited(base)
          base.const_set 'Context', Class.new(ActiveInteractor::Context::Base)
        end

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

        # The context class of the interactor
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #  end
        #
        #  MyInteractor.context_class
        #  #=> MyInteractor::Context
        def context_class
          const_get 'Context'
        end
      end
    end
  end
end
