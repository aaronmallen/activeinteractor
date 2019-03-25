# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Core
      extend ActiveSupport::Concern

      included do
        include Action
        include Callbacks
        include Context

        attr_reader :context

        def initialize(context = {})
          @context = self.class.context_class.new(self, context)
        end
      end
    end
  end
end
