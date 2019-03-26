# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Provides context status methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Status
      # Track that an Interactor has been called. The #called! method
      #  is used by the interactor being invoked with this context. After an
      #  interactor is successfully called, the interactor instance is tracked in
      #  the context for the purpose of potential future rollback
      #
      # @param interactor [ActiveInteractor::Base] an interactor instance
      # @return [Array<ActiveInteractor::Base>] all called interactors
      def called!(interactor)
        _called << interactor
      end

      # Fail the context instance. Failing a context raises an error
      #  that may be rescued by the calling interactor. The context is also flagged
      #  as having failed
      #
      # @example Fail an interactor context
      #  interactor = MyInteractor.new(name: 'Aaron')
      #  #=> <#MyInteractor name='Aaron'>
      #
      #  interactor.context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context name='Aaron'>
      #
      # @param errors [ActiveModel::Errors, Hash] errors to add to the context on failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @raise [Failure]
      def fail!(errors = {})
        self.errors.merge!(errors) unless errors.empty?
        @_failed = true
        raise Failure, self
      end

      # Whether the context instance has failed. By default, a new
      # context is successful and only changes when explicitly failed
      #
      # @note The #failure? method is the inverse of the #success? method
      #
      # @example Check if a context has failed
      #  context = MyInteractor::Context.new
      #  #=> <#MyInteractor::Context>
      #
      #  context.failure?
      #  false
      #
      #  context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context>
      #
      #  context.failure?
      #  #=> true
      #
      # @return [Boolean] `false` by default or `true` if failed
      def failure?
        @_failed || false
      end

      # Whether the context instance is successful. By default, a new
      # context is successful and only changes when explicitly failed
      #
      # @note the #success? method is the inverse of the #failure? method
      #
      # @example Check if a context has failed
      #  context = MyInteractor::Context.new
      #  #=> <#MyInteractor::Context>
      #
      #  context.success?
      #  true
      #
      #  context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context>
      #
      #  context.success?
      #  #=> false
      #
      # @return [Boolean] `true` by default or `false` if failed
      def success?
        !failure
      end

      alias fail? failure?
      alias successful? success?

      private

      def copy_flags!(context)
        @_called = context.send(:_called) if context.respond_to?(:_called, true)
        @_failed = context.failure? if context.respond_to?(:failure?)
      end

      def _called
        @_called ||= []
      end
    end
  end
end
