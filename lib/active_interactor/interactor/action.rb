# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides interactor action methods to included classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Action
      extend ActiveSupport::Concern

      class_methods do
        # Invoke an interactor. This is the primary public API method to an
        #  interactor.
        #
        # @example Run an interactor
        #  MyInteractor.perform(name: 'Aaron')
        #  #=> <#MyInteractor::Context name='Aaron'>
        #
        # @param context [Hash] properties to assign to the interactor context
        # @return [ActiveInteractor::Context::Base] an instance of context
        def perform(context = {})
          new(context).tap(&:call_perform).context
        end

        # Invoke an Interactor. The {.perform!} method behaves identically to
        #  the {.perform} method with one notable exception. If the context is failed
        #  during invocation of the interactor, the {ActiveInteractor::Context::Failure}
        #  is raised.
        #
        # @example Run an interactor
        #  MyInteractor.perform!(name: 'Aaron')
        #  #=> <#MyInteractor::Context name='Aaron'>
        #
        # @param context [Hash] properties to assign to the interactor context
        # @return [ActiveInteractor::Context::Base] an instance of context
        def perform!(context = {})
          new(context).tap(&:call_perform!).context
        end
      end

      # Calls {#call_perform!} and rescues {ActiveInteractor::Context::Failure}
      # @private
      def call_perform
        call_perform!
      rescue Context::Failure => exception
        ActiveInteractor.logger.error("ActiveInteractor: #{exception}")
      end

      # Calls {#perform} with callbacks and context validation
      # @private
      def call_perform!
        run_callbacks :perform do
          context.called!(self)
          fail_on_invalid_context!(:calling)
          perform
          fail_on_invalid_context!(:called)
        rescue # rubocop:disable Style/RescueStandardError
          context.rollback!
          raise
        end
      end

      # Calls {#rollback} with callbacks
      # @private
      def call_rollback
        run_callbacks :rollback do
          rollback
        end
      end

      # Invoke an Interactor instance without any hooks, tracking, or rollback
      # @abstract It is expected that the {#perform} method is overwritten
      #  for each interactor class.
      def perform; end

      # Reverse prior invocation of an Interactor instance.
      # @abstract Any interactor class that requires undoing upon downstream
      #  failure is expected to overwrite the {#rollback} method.
      def rollback; end
    end
  end
end
