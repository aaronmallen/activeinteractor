# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context status methods. Because {Status} is a module classes should include {Status} rather than inherit from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Status
      # Add an instance of {ActiveInteractor::Base interactor} to the list of {ActiveInteractor::Base interactors}
      # called on the {Base context}. This list is used when {#rollback!} is called on a {Base context} instance.
      #
      # @since 0.1.0
      #
      # @param interactor [Class] an {ActiveInteractor::Base interactor} instance
      # @return [Array<Class>] the list of called {ActiveInteractor::Base interactors}
      def called!(interactor)
        _called << interactor
      end

      # Fail the {Base context} instance. Failing an instance raises an error that may be rescued by the calling
      # {ActiveInteractor::Base interactor}. The instance is also flagged as having failed.
      #
      # @since 0.1.0
      #
      # @example Fail an interactor context
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform
      #       context.fail!
      #     end
      #   end
      #
      #   MyInteractor.perform!
      #   ActiveInteractor::Error::ContextFailure "<#MyInteractor::Context>"
      #
      # @param errors [ActiveModel::Errors, String] error messages for the failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @raise [Error::ContextFailure]
      def fail!(errors = nil)
        handle_errors(errors) if errors
        @_failed = true
        resolve
        raise ActiveInteractor::Error::ContextFailure, self
      end

      # Whether the {Base context} instance has {#fail! failed}. By default, a new instance is successful and only
      # changes when explicitly {#fail! failed}.
      #
      # @since 0.1.0
      # @note The {#failure?} method is the inverse of the {#success?} method
      #
      # @example Check if a context has failed
      #   result = MyInteractor.perform
      #   result.failure?
      #   #=> false
      #
      # @return [Boolean] `false` by default or `true` if {#fail! failed}.
      def failure?
        @_failed || false
      end
      alias fail? failure?

      # Resolve an instance of {Base context}.  Called when an interactor
      #  is finished with it's context.
      #
      # @since 1.0.3
      # @return [self] the instance of {Base context}
      def resolve
        resolve_errors
        self
      end

      # {#rollback! Rollback} an instance of {Base context}. Any {ActiveInteractor::Base interactors} the instance has
      # been passed via the {#called!} method are asked to roll themselves back by invoking their
      # {Interactor::Perform#rollback #rollback} methods. The instance is also flagged as rolled back.
      #
      # @since 0.1.0
      #
      # @return [Boolean] `true` if {#rollback! rolled back} successfully or `false` if already
      #  {#rollback! rolled back}
      def rollback!
        return false if @_rolled_back

        _called.reverse_each(&:rollback)
        @_rolled_back = true
      end

      # Whether the {Base context} instance is successful. By default, a new instance is successful and only changes
      # when explicitly {#fail! failed}.
      #
      # @since 0.1.0
      # @note The {#success?} method is the inverse of the {#failure?} method
      #
      # @example Check if a context has failed
      #   result = MyInteractor.perform
      #   result.success?
      #   #=> true
      #
      # @return [Boolean] `true` by default or `false` if {#fail! failed}
      def success?
        !failure?
      end
      alias successful? success?
    end
  end
end
