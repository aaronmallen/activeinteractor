# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Action
      extend ActiveSupport::Concern

      class_methods do
        def perform(context = {})
          new(context).tap(&:call_perform).context
        end

        def perform!(context = {})
          new(context).tap(&:call_perform!).context
        end
      end

      def call_perform
        call_perform!
      rescue Context::Failure => exception
        ActiveInteractor.logger.error("ActiveInteractor: #{exception}")
      end

      def call_perform!
        run_callbacks :perform do
          fail_on_invalid_context!(:calling)
          perform
          context.called!(self)
          fail_on_invalid_context!(:called)
        rescue # rubocop:disable Style/RescueStandardError
          context.rollback!
          raise
        end
      end

      def call_rollback
        run_callbacks :rollback do
          rollback
        end
      end

      def perform; end

      def rollback; end
    end
  end
end
