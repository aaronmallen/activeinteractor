# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      # Provides helper methods for context validation callbacks
      #
      # @api private
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.0.1
      # @version 0.1
      module Validation
        # Calls #validate_context and invokes
        #  {ActiveInteractor::Context::Status#fail! #fail!} if the context is invalid
        def fail_on_invalid_context!(validation_context = nil)
          context.fail! unless validate_context(validation_context)
        end

        # Validate the context given a validation_context with validation callbacks
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
