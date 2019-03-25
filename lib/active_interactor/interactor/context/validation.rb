# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      module Validation
        def fail_on_invalid_context!(validation_context = nil)
          context.fail! unless validate_context(validation_context)
        end

        def validate_context(validation_context = nil)
          run_callbacks :validation do
            init_validation_context = context.validation_context
            context.validation_context = validation_context || init_validation_context
            context.valid?
          ensure
            context.validation_context = init_validation_context
          end
        end
      end
    end
  end
end
