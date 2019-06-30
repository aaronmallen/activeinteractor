# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # A worker class responsible for thread safe execution
    #  of interactor {.perform} methods.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.2
    # @version 0.1
    class Worker
      delegate :run_callbacks, to: :interactor

      # A new instance of {Worker}
      # @param interactor [ActiveInteractor::Base] an interactor instance
      # @return [ActiveInteractor::Interactor::Worker] a new instance of {Worker}
      def initialize(interactor)
        @interactor = clone_interactor(interactor)
      end

      # Calls {#execute_perform!} and rescues {ActiveInteractor::Error::ContextFailure}
      # @return [ActiveInteractor::Context::Base] an instance of {ActiveInteractor::Context::Base}
      def execute_perform
        execute_perform!
      rescue ActiveInteractor::Error::ContextFailure => e
        ActiveInteractor.logger.error("ActiveInteractor: #{e}")
        context
      end

      # Calls {Interactor#perform} with callbacks and context validation
      # @raise [ActiveInteractor::Error::ContextFailure] if the context fails
      # @return [ActiveInteractor::Context::Base] an instance of {ActiveInteractor::Context::Base}
      def execute_perform!
        run_callbacks :perform do
          perform!
          finalize_context!
          context
        rescue # rubocop:disable Style/RescueStandardError
          context.rollback!
          raise
        end
      end

      # Calls {Interactor#rollback} with callbacks
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def execute_rollback
        run_callbacks :rollback do
          interactor.rollback
        end
      end

      private

      attr_reader :interactor

      def clone_interactor(interactor)
        cloned = interactor.clone
        cloned.send(:context=, cloned.send(:context).clone)
        cloned
      end

      def context
        interactor.send(:context)
      end

      def fail_on_invalid_context!(validation_context = nil)
        context.fail! if should_fail_on_invalid_context?(validation_context)
      end

      def finalize_context!
        context.clean! if interactor.should_clean_context?
        context.called!
      end

      def perform!
        fail_on_invalid_context!(:calling)
        interactor.perform
        fail_on_invalid_context!(:called)
      end

      def should_fail_on_invalid_context?(validation_context)
        !validate_context(validation_context) && interactor.fail_on_invalid_context?
      end

      def validate_context(validation_context = nil)
        run_callbacks :validation do
          init_validation_context = context.validation_context
          context.validation_context = validation_context || init_validation_context
          context.valid?
        ensure
          context.validation_context = init_validation_context
        end
      end
    end
  end
end
