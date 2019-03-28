# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Execution
      extend ActiveSupport::Concern

      DELEGATED_WORKER_METHODS = %i[
        execute_perform
        execute_perform!
        execute_rollback
      ].freeze

      included do
        delegate(*DELEGATED_WORKER_METHODS, to: :worker)
      end

      private

      def worker
        Worker.new(self)
      end
    end
  end
end
