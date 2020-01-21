# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context status methods included by all {Context::Base}
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Status
      # @api private
      # Track that an Interactor has been called. The {#called!} method
      #  is used by the interactor being invoked with this context. After an
      #  interactor is successfully called, the interactor instance is tracked in
      #  the context for the purpose of potential future rollback
      # @param interactor [ActiveInteractor::Base] the called interactor
      # @return [Array<ActiveInteractor::Base>] all called interactors
      def called!(interactor)
        _called << interactor
      end

      # Fail the context instance. Failing a context raises an error
      #  that may be rescued by the calling interactor. The context is also flagged
      #  as having failed
      #
      # @example Fail an interactor context
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform
      #       context.fail!
      #     end
      #   end
      #
      #   MyInteractor.perform!
      #   #=> ActiveInteractor::Error::ContextFailure: <#MyInteractor::Context>
      # @param errors [ActiveModel::Errors|nil] errors to add to the context on failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @raise [Error::ContextFailure]
      def fail!(errors = nil)
        merge_errors!(errors) if errors
        @_failed = true
        raise Error::ContextFailure, self
      end

      # Whether the context instance has failed. By default, a new
      # context is successful and only changes when explicitly failed
      # @note The {#failure?} method is the inverse of the {#success?} method
      # @example Check if a context has failed
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform; end
      #   end
      #
      #   result = MyInteractor.perform
      #   #=> <#MyInteractor::Context>
      #
      #   result.failure?
      #   #=> false
      # @return [Boolean] `false` by default or `true` if failed
      def failure?
        @_failed || false
      end
      alias fail? failure?

      # Roll back an interactor context. Any interactors to which this
      # context has been passed and which have been successfully called are asked
      # to roll themselves back by invoking their
      # {ActiveInteractor::Base#rollback} instance methods.
      # @example Rollback an interactor's context
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform
      #       context.fail!
      #     end
      #
      #     def rollback
      #       context.user&.destroy
      #     end
      #   end
      #
      #   user = User.create
      #   #=> <#User>
      #
      #   result = MyInteractor.perform(user: user)
      #   #=> <#MyInteractor::Context user=<#User>>
      #
      #   result.user.destroyed?
      #   #=> true
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def rollback!
        return false if @_rolled_back

        _called.reverse_each(&:rollback)
        @_rolled_back = true
      end

      # Whether the context instance is successful. By default, a new
      # context is successful and only changes when explicitly failed
      # @note the {#success?} method is the inverse of the {#failure?} method
      # @example Check if a context is successful
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform; end
      #   end
      #
      #   result = MyInteractor.perform
      #   #=> <#MyInteractor::Context>
      #
      #   result.success?
      #   #=> true
      # @return [Boolean] `true` by default or `false` if failed
      def success?
        !failure?
      end
      alias successful? success?

      private

      def _called
        @_called ||= []
      end

      def copy_called!(context)
        value = context.instance_variable_get('@_called') || []
        instance_variable_set('@_called', value)
      end

      def copy_flags!(context)
        %w[_failed _rolled_back].each do |flag|
          value = context.instance_variable_get("@#{flag}")
          instance_variable_set("@#{flag}", value)
        end
      end
    end
  end
end
