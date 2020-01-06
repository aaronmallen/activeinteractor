# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/string/inflections'

module ActiveInteractor
  module Interactor
    # Interactor context methods included by all {Base}
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @!attribute [rw] context
    #  @api private
    #  @return [Context::Base] an instance of the interactor's context class
    module Context
      # @!method context_fail!(errors = nil)
      # Fail the interactor's context
      # @since 1.0.0
      # @see ActiveInteractor::Context::Base#fail!

      # @!method context_rollback!
      # Rollback the interactor's context
      # @since 1.0.0
      # @see ActiveInteractor::Context::Base#rollback!

      # @!method context_valid?(context = nil)
      # Whether or not the interactor's context is valid
      # @since 1.0.0
      # @see ActiveInteractor::Context::Base#valid?
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          delegate :fail!, :rollback!, to: :context, prefix: true
          delegate(*ActiveModel::Validations.instance_methods, to: :context, prefix: true)
          delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context, prefix: true)

          private

          attr_accessor :context
        end
      end

      # Interactor context class methods extended by all {Base}
      module ClassMethods
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :context_class, prefix: :context)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context_class, prefix: :context)
        # @!method context_attributes(*attributes)
        # Set or get attributes defined on the interactor's context class
        # @since 0.0.1
        # @see ActiveInteractor::Context::Attributes#attributes
        delegate :attributes, to: :context_class, prefix: :context

        # The context class of the interactor
        # @note If a context class is not defined on the interactor
        #  with {#contextualize_with} ActiveInteractor will attempt
        #  to find a class with the naming conventions:
        #    `MyInteractor::Context` or `MyInteractorContext`
        #  if no matching context class is found a context class
        #  will be created with the naming convention: `MyInteractor::Context`.
        # @example With an existing class named `MyInteractor::Context`
        #  class MyInteractor::Context < ActiveInteractor::Context::Base
        #  end
        #
        #  class MyInteractor < ActiveInteractor::Base
        #  end
        #
        #  MyInteractor.context_class
        #  #=> MyInteractor::Context
        # @example With an existing class named `MyInteractorContext`
        #  class MyInteractorContext < ActiveInteractor::Context::Base
        #  end
        #
        #  class MyInteractor < ActiveInteractor::Base
        #  end
        #
        #  MyInteractor.context_class
        #  #=> MyInteractorContext
        # @example With no existing context class
        #  class MyInteractor < ActiveInteractor::Base
        #  end
        #
        #  MyInteractor.context_class
        #  #=> MyInteractor::Context
        # @return [Class] the interactor's context class
        def context_class
          @context_class ||= ActiveInteractor::Context::Loader.find_or_create(self)
        end

        # Manual define an interactor's context class
        # @since 1.0.0
        # @example
        #   class AGenericContext < ActiveInteractor::Context::Base
        #   end
        #
        #   class MyInteractor < ActiveInteractor::Base
        #     contextualize_with :a_generic_context
        #   end
        #
        #   MyInteractor.context_class
        #   #=> AGenericContext
        # @param klass [String|Symbol|Class] the context class
        # @raise [Error::InvalidContextClass] if no matching class can be found
        # @return [Class] the context class
        def contextualize_with(klass)
          @context_class = begin
            context_class = klass.to_s.classify.safe_constantize
            raise(Error::InvalidContextClass, klass) unless context_class

            context_class
          end
        end
      end

      # @api private
      # @param context [Context::Base|Hash] attributes to assign to the context
      # @return [Base] a new instane of {Base}
      def initialize(context = {})
        @context = self.class.context_class.new(context)
      end

      # @api private
      # Mark the interactor's context as called and return the context
      # @since 1.0.0
      # @return [Context::Base] an instance of the interactor's context class
      def finalize_context!
        context.called!(self)
        context
      end
    end
  end
end
