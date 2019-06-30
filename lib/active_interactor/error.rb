# frozen_string_literal: true

module ActiveInteractor
  # ActiveInteractor::Error module
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.5
  # @version 0.1
  module Error
    # Raised when an interactor context fails
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.5
    # @version 0.1
    #
    # @!attribute [r] context
    #  @return [Base] an instance of {Base}
    class ContextFailure < StandardError
      attr_reader :context

      # A new instance of {ContextFailure}
      # @param context [ActiveInteractor::Context::Base] an
      #  instance of {ActiveInteractor::Context::Base}
      # @return [ContextFailure] a new instance of {ContextFailure}
      def initialize(context = nil)
        @context = context
        super
      end
    end
  end
end
