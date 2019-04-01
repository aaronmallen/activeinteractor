# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides worker methods to included classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.2
    # @version 0.2
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
