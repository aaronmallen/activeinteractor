# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Raised when an interactor context fails
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    #
    # @!attribute [r] context
    #  @return [Base] an instance of {Base}
    class Failure < StandardError
      attr_reader :context

      # A new instance of {Failure}
      # @param context [Hash] an instance of {Base}
      # @return [Failure] a new instance of {Failure}
      def initialize(context = {})
        @context = context
        super
      end
    end
  end
end
