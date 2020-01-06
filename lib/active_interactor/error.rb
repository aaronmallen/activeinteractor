# frozen_string_literal: true

module ActiveInteractor
  # ActiveInteractor errors
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.5
  module Error
    # Raised when an interactor context fails.
    # @!attribute [r] context
    #  @return [Context::Base] an instance of {Context::Base}
    class ContextFailure < StandardError
      attr_reader :context

      # @param context [Context::Base] the failed context instance.
      # @return [ContextFailure] a new instance of {ContextFailure}.
      def initialize(context = nil)
        @context = context
        context_class_name = context&.class&.name || 'Context'
        super("#{context_class_name} failed!")
      end
    end

    # Raised when an invalid context class is assigned to an interactor.
    # @since 1.0.0
    # @!attribute [r] class_name
    #  @return [String|nil] the class name of the context
    class InvalidContextClass < StandardError
      attr_reader :class_name

      # @param class_name [String] the context class name
      # @return [InvalidContextClass] a new instance of {InvalidContextClass}
      def initialize(class_name = nil)
        @class_name = class_name
        super("invalid context class #{class_name}")
      end
    end
  end
end
