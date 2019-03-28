# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Execution
      extend ActiveSupport::Concern

      DELEGATED_WORKER_METHODS = %i[
        execute_perform
        execute_perform!
        execute_rollback
        skip_clean_context!
      ].freeze

      included do
        delegate(*DELEGATED_WORKER_METHODS, to: :worker)
      end

      private

      def worker
        Worker.new(self, worker_options)
      end

      def worker_options
        {
          fail_on_invalid_context: self.class.__fail_on_invalid_context,
          clean_after_perform: self.class.__clean_after_perform
        }
      end
    end
  end
end
