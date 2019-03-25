# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Core
      extend ActiveSupport::Concern

      included do
        include Action
        include Callbacks
        include Context

        def initialize(context = {})
          @context = self.class.context_class.new(context)
        end
      end
    end
  end
end
