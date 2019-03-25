# frozen_string_literal: true

module ActiveInteractor
  module Context
    module Action
      def rollback!
        return false if @_rolled_back

        _called.reverse_each(&:call_rollback)
        @_rolled_back = true
      end
    end
  end
end
