# frozen_string_literal: true

require 'active_support/core_ext/module'

require_relative './result'

module ActiveInteractor
  class Worker
    module ContextMethods
      private

      def build_input_context
        if options.skip_build_input_context_callbacks?
          interactor.initialize_input_context
        else
          interactor.run_callbacks :build_input_context do
            interactor.initialize_input_context
          end
        end
      end

      def build_output_context
        if options.skip_build_output_context_callbacks?
          interactor.initialize_output_context
        else
          interactor.run_callbacks :build_runtime_context do
            interactor.initialize_output_context
          end
        end
      end

      def build_runtime_context
        if options.skip_build_runtime_context_callbacks?
          interactor.initialize_runtime_context
        else
          interactor.run_callbacks :build_runtime_context do
            interactor.initialize_runtime_context
          end
        end
      end

      def validate_input_context!
        return true unless options.validate_input?

        if options.skip_input_validation_callbacks?
          interactor.input_context.valid?
        else
          interactor.run_callbacks :input_validation do
            interactor.input_context.valid?
          end
        end
      end

      def validate_output_context!
        return true unless options.validate_output?

        if options.skip_output_validation_callbacks?
          interactor.output_context.valid?
        else
          interactor.run_callbacks :output_validation do
            interactor.output_context.valid?
          end
        end
      end
    end

    module ResultMethods
      private

      def failure_result
        if options.skip_failure_callbacks?
          result
        else
          interactor.run_callbacks :failure do
            result
          end
        end
      end

      def failure_result_with_rollback
        return failure_result if options.skip_rollback?

        if options.skip_rollback_callbacks?
          interactor.status.called.reverse_each(&:rollback)
        else
          interactor.run_callbacks :rollback do
            interactor.status.called.reverse_each(&:rollback)
          end
        end

        failure_result
      end

      def input_result
        build_input_context
        failure_result unless validate_input_status!
      end

      def output_result
        build_output_context
        failure_result_with_rollback unless validate_output_status!
      end

      def result
        Result.new(
          input_context: interactor.input_context.dup,
          runtime_context: interactor.runtime_context.dup,
          output_context: interactor.output_context.dup,
          status: interactor.status.dup
        )
      end

      def runtime_result
        build_runtime_context
        failure_result_with_rollback unless interactor_perform!
      end
    end

    module StatusMethods
      private

      def validate_input_status!
        return true if validate_input_context!

        interactor.status.fail_on_input!
        false
      end

      def validate_output_status!
        return true if validate_output_context!

        interactor.status.fail_on_output!
        false
      end
    end

    include ContextMethods
    include ResultMethods
    include StatusMethods
    delegate :options, to: :interactor

    def initialize(interactor)
      @interactor = interactor.deep_dup
    end

    def execute_interaction
      input_result || runtime_result || output_result || result
    end

    private

    attr_reader :interactor

    def interactor_perform!
      if options.skip_perform_callbacks?
        interactor.interaction
      else
        interactor.run_callbacks :perform do
          interactor.interaction
        end
      end

      interactor.status.called!(interactor)
      interactor.status.successful?
    end
  end
end
