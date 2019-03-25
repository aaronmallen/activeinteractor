# frozen_string_literal: true

module ActiveInteractor
  module Context
    class Failure < StandardError
      attr_reader :context

      def initialize(context = {})
        @context = context
        super
      end
    end
  end
end
