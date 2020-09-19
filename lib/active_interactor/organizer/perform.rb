# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # Organizer perform methods. Because {Perform} is a module classes should include {Perform} rather than inherit
    # from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Perform
      # Organizer perform class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      #
      # @!attribute [r] parallel
      #  If `true` the {Base organizer} will call {Interactor::Perform#perform #perform} on its
      #  {Organizer::Organize::ClassMethods#organize .organized} {ActiveInteractor::Base interactors} in parallel.
      #  An {Base organizer} will have {.parallel} `false` by default.
      #
      #  @!scope class
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or not to call {Interactor::Perform#perform #perform} on its
      #   {Organizer::Organize::ClassMethods#organize .organized} {ActiveInteractor::Base interactors} in parallel.
      module ClassMethods
        # Set {.parallel} to `true`
        #
        # @example a basic {Base organizer} set to perform in parallel
        #   class MyOrganizer < ActiveInteractor::Organizer::Base
        #     perform_in_parallel
        #   end
        def perform_in_parallel
          self.parallel = true
        end
      end

      def self.included(base)
        base.class_eval do
          class_attribute :parallel, instance_writer: false, default: false
        end
      end

      # Call the {Organize::ClassMethods#organized .organized} {ActiveInteractor::Base interactors}
      # {Interactor::Perform#perform #perform}. An {Base organizer} is expected not to define its own
      # {Interactor::Perform#perform #perform} method in favor of this default implementation.
      def perform
        if self.class.parallel
          perform_in_parallel
        else
          perform_in_order
        end
      end

      private

      def execute_interactor(interface, fail_on_error = false, perform_options = {})
        interface.perform(self, context, fail_on_error, perform_options)
      end

      def execute_interactor_with_callbacks(interface, fail_on_error = false, perform_options = {})
        args = [interface, fail_on_error, perform_options]
        return execute_interactor(*args) if options.skip_each_perform_callbacks

        run_callbacks :each_perform do
          execute_interactor(*args)
        end
      end

      def merge_contexts(contexts)
        contexts.each { |context| @context.merge!(context) }
        context_fail! if contexts.any?(&:failure?)
      end

      def execute_and_merge_contexts(interface)
        result = execute_interactor_with_callbacks(interface, true)
        return if result.nil?

        context.merge!(result)
        context_fail! if result.failure?
      end

      def perform_in_order
        self.class.organized.each do |interface|
          execute_and_merge_contexts(interface)
        end
      rescue ActiveInteractor::Error::ContextFailure => e
        context.merge!(e.context)
      end

      def perform_in_parallel
        results = self.class.organized.map do |interface|
          Thread.new { execute_interactor_with_callbacks(interface, false, skip_rollback: true) }
        end
        merge_contexts(results.map(&:value))
      end
    end
  end
end
