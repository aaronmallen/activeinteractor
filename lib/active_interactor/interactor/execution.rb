# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Execution
      extend ActiveSupport::Concern

      included do
        delegate :execute_perform, :execute_perform!, :execute_rollback, to: :worker
      end

      private

      def worker
        Worker.new(self)
      end
    end
  end
end
