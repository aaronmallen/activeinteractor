# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Raised when an interactor context fails
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.2
    #
    # @!attribute [r] context
    #  @return [Base] an instance of {Base}
    class Failure < StandardError
      attr_reader :context

      # A new instance of {Failure}
      # @param context [ActiveInteractor::Context::Base] an
      #  instance of {ActiveInteractor::Context::Base}
      # @return [Failure] a new instance of {Failure}
      def initialize(context = nil)
        @context = context
        super
      end
    end
  end
end
