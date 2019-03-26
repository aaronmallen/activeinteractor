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

      # Calls {#validate_context} and invokes
      #  {ActiveInteractor::Context::Base#fail! #fail!} if the context is invalid
      def fail_on_invalid_context!(validation_context = nil)
        context.fail! if should_fail_on_invalid_context?(validation_context)
      end

      # Whether or not a context should be cleaned after `perform` is
      #  invoked.
      #
      # @private
      #
      # @return [Boolean] `true` if the context should be cleaned
      #  `false` if it should not.
      def should_clean_context?
        (@should_clean_context && __clean_after_perform) || false
      end

      # Skip {ActiveInteractor::Context::Base#clean! #clean! on an interactor
      #  context that calls the {Callbacks.clean_context_on_completion} class method.
      #  This method is meant to be invoked by organizer interactors
      #  to ensure contexts are approriately passed between interactors.
      #
      # @private
      #
      # @return [Boolean] `true` if the context should be cleaned
      #  `false` if it should not.
      def skip_clean_context!
        @should_clean_context = false
      end

      # Validate the context given a validation_context with validation callbacks
      def validate_context(validation_context = nil)
        run_callbacks :validation do
          init_validation_context = context.validation_context
          context.validation_context = validation_context || init_validation_context
          context.valid?
        ensure
          context.validation_context = init_validation_context
        end
      end

      private

      def should_fail_on_invalid_context?(validation_context)
        !validate_context(validation_context) && self.class.__fail_on_invalid_context
      end
    end
  end
end
