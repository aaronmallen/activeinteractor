# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # @api private
    # Thread safe execution of interactor {Interactor#perform #perform} and
    #  {Interactor#rollback #rollback} methods.
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.2
    class Worker
      # @param interactor [Base] an instance of interactor
      # @return [Worker] a new instance of {Worker}
      def initialize(interactor)
        @interactor = interactor.dup
      end

      # Calls {#execute_perform!} and rescues {Error::ContextFailure}
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform
        execute_perform!
      rescue Error::ContextFailure => e
        ActiveInteractor.logger.error("ActiveInteractor: #{e}")
        context
      end

      # Calls {Interactor#perform} with callbacks and context validation
      # @raise [Error::ContextFailure] if the context fails
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform!
        execute_context!
      rescue StandardError => e
        handle_error(e)
      end

      # Calls {Interactor#rollback} with callbacks
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def execute_rollback
        execute_interactor_rollback!
      end

      private

      attr_reader :context, :interactor

      def execute_context!
        execute_context_with_callbacks!
      end

      def execute_context_with_callbacks!
        interactor.run_callbacks :perform do
          execute_context_with_validation_check!
          @context = interactor.finalize_context!
        end
      end

      def execute_context_with_validation!
        validate_on_calling
        interactor.perform
        validate_on_called
      end

      def execute_context_with_validation_check!
        execute_context_with_validation!
      end

      def execute_interactor_rollback!
        interactor.run_callbacks :rollback do
          interactor.context_rollback!
        end
      end

      def handle_error(exception)
        @context = interactor.finalize_context!
        execute_rollback
        raise exception
      end

      def validate_context(validation_context = nil)
        interactor.run_callbacks :validation do
          interactor.context_valid?(validation_context)
        end
      end

      def validate_on_calling
        interactor.context_fail! unless validate_context(:calling)
      end

      def validate_on_called
        interactor.context_fail! unless validate_context(:called)
      end
    end
  end
end
