# frozen_string_literal: true

module ActiveInteractor
  module Context
    module Status
      def called!(interactor)
        _called << interactor
      end

      def fail!(errors = {})
        self.errors.merge!(errors) unless errors.empty?
        @_failed = true
        raise Failure, self
      end

      def failure?
        @_failed || false
      end

      def success?
        !failure
      end

      alias fail? failure?
      alias successful? success?

      private

      def _called
        @_called ||= []
      end
    end
  end
end
