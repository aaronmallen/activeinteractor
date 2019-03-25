# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      module Generation
        extend ActiveSupport::Concern

        included do
          const_set 'Context', Class.new(ActiveInteractor::Context::Base)
        end

        class_methods do
          def context_class
            const_get 'Context'
          end
        end
      end
    end
  end
end
