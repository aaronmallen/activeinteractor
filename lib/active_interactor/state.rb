# frozen_string_literal: true

module ActiveInteractor
  # An object to manage interactor state.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since unreleased
  #
  # @!attribute [r] called
  #  A list of called interactors
  #  @return [Array<#rollback>] called interactors
  class State
    attr_reader :called

    # Initialize a new instance of {State}
    #
    # @return [State] a new instance of {State}
    def initialize
      @called = []
    end

    # Add an interactor to the {#called} interactors
    #
    # @param interactor [#rollback] an {ActiveInteractor::Base interactor} to add to the list
    #  of {#called} interactors
    # @return [self] the instance of {State}
    def called!(interactor)
      return self unless interactor.respond_to?(:rollback)

      called << interactor
      self
    end

    # {State} errors
    #
    # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
    # @return [ActiveModel::Errors] an instance of
    #  {https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors}
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Fail the {State} instance.
    #
    # @example Fail an interactor state
    #  class MyInteractor < ActiveInteractor::Base
    #    def perform
    #      state.fail!
    #    end
    #  end
    #
    #  result = MyInteractor.perform
    #  result.state.successful?
    #  #=> false
    #
    # @param errors [String, ActiveModel::Errors, nil] errors for the failure
    # @return [self] the instance of {State}
    def fail!(errors = nil)
      handle_errors(errors) if errors
      @_failed = true
      self
    end

    # Whether the {State} instance has {#fail! failed}. By default, a new instance is successful and only changes when
    # explicitly {#fail! failed}.
    #
    # @note The {#failure?} method is the inverse of the {#success?} method
    #
    # @example Check if a state has failed
    #   result = MyInteractor.perform
    #   result.state.failure?
    #   #=> false
    #
    # @return [Boolean] `false` by default or `true` if {#fail! failed}.
    def failure?
      @_failed || false
    end
    alias fail? failure?

    # Rollback interactors on the {State} instance's list of {#called} interactors. Any
    # {ActiveInteractor::Base interactors} the instance has been passed via the {#called!} method are asked to roll
    # themselves back by invoking their {Interactor::Perform#rollback #rollback} methods. The instance is also flagged
    # as {#rolled_back?}.
    #
    # @return [self] the instance of {State}
    def rollback!
      return self if rolled_back? || called.empty?

      called.reverse_each(&:rollback)
      @_rolled_back = true
      self
    end

    # Whether the {State} instance has {#rollback! rolled back}.
    #
    # @example Check if a state has been rolled back
    #   result = MyInteractor.perform
    #   result.state.rolled_back?
    #   #=> false
    #
    # @return [Boolean] `false` by default or `true` if {#rollback! rolled back}.
    def rolled_back?
      @_rolled_back || false
    end

    # Whether the {State} instance is successful. By default, a new instance is successful and only changes
    # when explicitly {#fail! failed}.
    #
    # @note The {#success?} method is the inverse of the {#failure?} method
    #
    # @example Check if a state has failed
    #   result = MyInteractor.perform
    #   result.state.success?
    #   #=> true
    #
    # @return [Boolean] `true` by default or `false` if {#fail! failed}
    def successful?
      !failure?
    end
    alias success? successful?

    private

    def handle_errors(errors)
      if errors.is_a?(String)
        self.errors.add(:interaction, errors)
      else
        self.errors.merge!(errors)
      end
    end
  end
end
