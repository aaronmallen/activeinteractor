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
      # @param options [PerformOptions|Hash] execution options for the interactor perform step
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform(options = PerformOptions.new)
        execute_perform!(options)
      rescue Error::ContextFailure => e
        ActiveInteractor.logger.error("ActiveInteractor: #{e}")
        context
      end

      # Calls {Interactor#perform} with callbacks and context validation
      # @param options [PerformOptions|Hash] execution options for the interactor perform step
      # @raise [Error::ContextFailure] if the context fails
      # @return [Context::Base] an instance of {Context::Base}
      def execute_perform!(options = PerformOptions.new)
        options = parse_options(options)
        execute_context!(options)
      rescue StandardError => e
        handle_error(e, options)
      end

      # Calls {Interactor#rollback} with callbacks
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def execute_rollback(options = PerformOptions.new)
        options = parse_options(options)
        return if options.skip_rollback

        execute_interactor_rollback!(options)
      end

      private

      attr_reader :context, :interactor

      def execute_context!(options)
        if options.skip_perform_callbacks
          execute_context_with_validation_check!(options)
        else
          execute_context_with_callbacks!(options)
        end
      end

      def execute_context_with_callbacks!(options)
        interactor.run_callbacks :perform do
          execute_context_with_validation_check!(options)
          @context = interactor.finalize_context!
        end
      end

      def execute_context_with_validation!(options)
        validate_on_calling(options)
        interactor.perform
        validate_on_called(options)
      end

      def execute_context_with_validation_check!(options)
        return interactor.perform unless options.validate

        execute_context_with_validation!(options)
      end

      def execute_interactor_rollback!(options)
        return interactor.context_rollback! if options.skip_rollback_callbacks

        interactor.run_callbacks :rollback do
          interactor.context_rollback!
        end
      end

      def handle_error(exception, options)
        @context = interactor.finalize_context!
        execute_rollback(options)
        raise exception
      end

      def parse_options(options)
        @options = options.is_a?(PerformOptions) ? options : PerformOptions.new(options)
      end

      def validate_context(validation_context = nil)
        interactor.run_callbacks :validation do
          interactor.context_valid?(validation_context)
        end
      end

      def validate_on_calling(options)
        return unless options.validate_on_calling

        interactor.context_fail! unless validate_context(:calling)
      end

      def validate_on_called(options)
        return unless options.validate_on_called

        interactor.context_fail! unless validate_context(:called)
      end
    end
  end
end
