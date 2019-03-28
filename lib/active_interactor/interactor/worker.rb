# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    class Worker
      delegate :run_callbacks, to: :interactor

      def initialize(interactor, options = {})
        @interactor = clone_interactor(interactor)
        @options = options
      end

      # Calls {#execute_perform!} and rescues {ActiveInteractor::Context::Failure}
      def execute_perform
        execute_perform!
      rescue ActiveInteractor::Context::Failure => exception
        ActiveInteractor.logger.error("ActiveInteractor: #{exception}")
        context
      end

      # Calls {Interactor#perform} with callbacks and context validation
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

      # Calls {#rollback} with callbacks
      def execute_rollback
        run_callbacks :rollback do
          interactor.rollback
        end
      end

      # Skip {ActiveInteractor::Context::Base#clean! #clean! on an interactor
      #  context that calls the {Callbacks.clean_context_on_completion} class method.
      #  This method is meant to be invoked by organizer interactors
      #  to ensure contexts are approriately passed between interactors.
      #
      # @return [Boolean] `true` if the context should be cleaned
      #  `false` if it should not.
      def skip_clean_context!
        @should_clean_context = false
      end

      private

      attr_reader :interactor, :options

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
        context.clean! if should_clean_context?
        context.called!(interactor)
      end

      def perform!
        fail_on_invalid_context!(:calling)
        interactor.perform
        fail_on_invalid_context!(:called)
      end

      def should_fail_on_invalid_context?(validation_context)
        !validate_context(validation_context) && options[:fail_on_invalid_context]
      end

      def should_clean_context?
        (@should_clean_context && options[:clean_after_perform]) || false
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
