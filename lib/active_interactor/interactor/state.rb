# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # The Interactor State object.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    #
    # @!attribute [r] called
    #  Called interactors on the {State} instance. Used for rollback
    #  @return [Array<ActiveInteractor::Base>] the list of called {ActiveInteractor::Base interactors}
    #
    # @attribute [r] rolled_back
    #  Rolled back interactors on the {State} instance
    #  @return [Array<ActiveInteractor::Base>] the list of rolledback {ActiveInteractor::Base interactors}
    #
    # @!attribute [r] status
    #  The {State} instance's status. Defaults to {State::SUCCESS_STATUS}
    #  @return [Symbol] {State} status
    class State
      # @return [Symbol] {State} failure status
      FAILURE_STATUS = :failed
      # @return [Symobl] {State} success status
      SUCCESS_STATUS = :success

      attr_reader :called, :rolled_back, :status

      # Initialize a new instance of {State}
      # @return {State} a new instance of {State}
      def initialize
        @called = []
        @rolled_back = []
        @status = SUCCESS_STATUS
      end

      # Add an instance of {ActiveInteractor::Base interactor} to the list of {ActiveInteractor::Base interactors}
      # called on the {State state}.  This list is used for rolling back interactors on failure.
      #
      # @param interactor [ActiveInteractor::Base] an instance of {ActiveInteractor::Base interactor}
      # @return [Array<ActiveInteractor::Base>] the list of called {ActiveInteractor::Base interactors}
      def called!(interactor)
        called << interactor
      end

      # Mark the {State} instance as failed.
      #
      # @return [#status] the {State} instance {#status}
      def fail!
        @status = FAILURE_STATUS
      end

      # Whether the {State} instance has {#fail! failed}. By default a new instance is successful and only
      # changes when explicitly {#fail! failed}
      #
      # @return [Boolean] `fasle` by default or `true` if {#fail! failed}
      def failure?
        @status == FAILURE_STATUS
      end
      alias fail? failure?

      # Add an instance of {ActiveInteractor::Base interactor} to the list of {ActiveInteractor::Base interactors}
      # that have been {ActiveInteractor::Base #rollback rolled back}
      #
      # @param interactor [ActiveInteractor::Base] an instance of {ActiveInteractor::Base interactor}
      # @return [Array<ActiveInteractor::Base>] the list of rolled back {ActiveInteractor::Base interactors}
      def rolled_back!(interactor)
        rolled_back << interactor
      end

      # Whether the {State} instance is sucessful. By default a new instance is successful and only
      # changes when explicitly {#fail! failed}
      #
      # @return [Boolean] `true` by default or `false` if {#fail! failed}
      def success?
        !failure?
      end
      alias successful? success?
    end
  end
end
