# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Provides context action methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Action
      # Roll back an interactor context. Any interactors to which this
      # context has been passed and which have been successfully called are asked
      # to roll themselves back by invoking their
      # {Interactor::Action#rollback #rollback} instance methods.
      #
      # @example Rollback an interactor's context
      #  context = MyInteractor.perform(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      #  context.rollback!
      #  #=> true
      #
      #  context
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def rollback!
        return false if @_rolled_back

        _called.reverse_each(&:call_rollback)
        @_rolled_back = true
      end
    end
  end
end
