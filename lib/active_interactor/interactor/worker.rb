# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # @api private
    # Thread safe execution of interactor {Interactor#perform #perform} and
    #  {Interactor#rollback #rollback} methods.
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.2
    class Worker
      delegate :run_callbacks, to: :interactor

      # @param interactor [Base] an instance of interactor
      # @return [Worker] a new instance of {Worker}
      def initialize(interactor)
        @interactor = interactor.dup
      end

      # Calls {#execute_perform!} and rescues {Error::ContextFailure}
      # @param options [Hash] execution options for the interactor perform step
      # @option options [Boolean] skip_rollback whether or not to skip rollback
      #  on the interactor
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform(options = {})
        execute_perform!(options)
      rescue Error::ContextFailure => e
        ActiveInteractor.logger.error("ActiveInteractor: #{e}")
        context
      end

      # Calls {Interactor#perform} with callbacks and context validation
      # @param options [Hash] execution options for the interactor perform step
      # @option options [Boolean] skip_rollback whether or not to skip rollback
      #  on the interactor
      # @raise [Error::ContextFailure] if the context fails
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform!(options = {})
        run_callbacks :perform do
          execute_context!
          @context = interactor.finalize_context!
        rescue StandardError => e
          handle_error(e, options)
        end
      end

      # Calls {Interactor#rollback} with callbacks
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def execute_rollback
        run_callbacks :rollback do
          interactor.context_rollback!
        end
      end

      private

      attr_reader :context, :interactor

      def execute_context!
        interactor.context_fail! unless validate_context(:calling)
        interactor.perform
        interactor.context_fail! unless validate_context(:called)
      end

      def handle_error(exception, options)
        @context = interactor.finalize_context!
        execute_rollback unless options[:skip_rollback]
        raise exception
      end

      def validate_context(validation_context = nil)
        run_callbacks :validation do
          interactor.context_valid?(validation_context)
        end
      end
    end
  end
end
