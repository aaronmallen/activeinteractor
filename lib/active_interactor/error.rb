# frozen_string_literal: true

module ActiveInteractor
  # ActiveInteractor errors
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.5
  module Error
    # Raised when an {Base interactor} {Context::Base context} {Context::Status#fail! fails}.
    #
    # @!attribute [r] context
    #  An instance of {Context::Base context} used for debugging.
    #
    #  @return [Context::Base] an instance of {Context::Base}
    class ContextFailure < StandardError
      attr_reader :context

      # Initialize a new instance of {ContextFailure}
      #
      # @param context [Class, nil] an instance of {Context::Base context}
      # @return [ContextFailure] a new instance of {ContextFailure}
      def initialize(context = nil)
        @context = context
        context_class_name = context&.class&.name || 'Context'
        super("#{context_class_name} failed!")
      end
    end

    # Raised when an invalid {Context::Base context} class is assigned to an {Base interactor}.
    #
    # @since 1.0.0
    #
    # @!attribute [r] class_name
    #  The class name of the {Context::Base context} used for debugging.
    #
    #  @return [String|nil] the class name of the {Context::Base context}
    class InvalidContextClass < StandardError
      attr_reader :class_name

      def initialize(class_name = nil)
        @class_name = class_name
        super("invalid context class #{class_name}")
      end
    end
  end
end
