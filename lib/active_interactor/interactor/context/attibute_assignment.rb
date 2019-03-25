# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      module AttributeAssignment
        extend ActiveSupport::Concern

        class_methods do
          def context_attributes(*attributes)
            context_class.attributes = attributes
          end
        end
      end
    end
  end
end
