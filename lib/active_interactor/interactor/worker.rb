# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # A worker class to call {Base interactor} {Interactor::Perform#perform #perform} and
    # {Interactor::Perform#rollback #rollback} methods in a thread safe manner.
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.0
    class Worker
      # Initialize a new instance of {Worker}
      #
      # @param interactor [Base] an {Base interactor} instance
      # @return [Worker] a new instance of {Worker}
      def initialize(interactor)
        @interactor = interactor.deep_dup
      end

      # Run the {Base interactor} instance's {Interactor::Perform#perform #perform} with callbacks and validation.
      #
      # @return [Class] a {ActiveInteractor::Context::Base context} instance
      def execute_perform
        execute_perform!
      rescue Error::ContextFailure => e
        ActiveInteractor.logger.error("ActiveInteractor: #{e}")
        context
      end

      # Run the {Base interactor} instance's {Interactor::Perform#perform #perform} with callbacks and validation
      # without rescuing {Error::ContextFailure}.
      #
      # @raise [Error::ContextFailure] if the {Base interactor} fails it's {ActiveInteractor::Context::Base context}
      # @return [Class] a {ActiveInteractor::Context::Base context} instance
      def execute_perform!
        execute_context!
      rescue StandardError => e
        handle_error(e)
      end

      # Run the {Base interactor} instance's {Interactor::Perform#rollback #rollback} with callbacks
      #
      # @return [Boolean] `true` if context was successfully rolled back
      def execute_rollback
        return if interactor.options.skip_rollback

        execute_interactor_rollback!
      end

      private

      attr_reader :context, :interactor

      def execute_context!
        if interactor.options.skip_perform_callbacks
          execute_context_with_validation_check!
        else
          execute_context_with_callbacks!
        end
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
        return interactor.perform unless interactor.options.validate

        execute_context_with_validation!
      end

      def execute_interactor_rollback!
        return interactor.context_rollback! if interactor.options.skip_rollback_callbacks

        interactor.run_callbacks :rollback do
          interactor.context_rollback!
        end
      end

      def handle_error(exception)
        @context = interactor.finalize_context!
        interactor.run_callbacks :failure
        execute_rollback
        ActiveSupport::Notifications.instrument('interactor failure') { raise exception }
      end

      def validate_context(validation_context = nil)
        interactor.run_callbacks :validation do
          interactor.context_valid?(validation_context)
        end
      end

      def validate_on_calling
        return unless interactor.options.validate_on_calling

        interactor.context_fail! unless validate_context(:calling)
      end

      def validate_on_called
        return unless interactor.options.validate_on_called

        interactor.context_fail! unless validate_context(:called)
      end
    end
  end
end
