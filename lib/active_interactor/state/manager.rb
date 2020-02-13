# frozen_string_literal: true

module ActiveInteractor
  module State
    # A {ActiveInteractor::Base interactor} state manangement object.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    class Manager
      include ActiveInteractor::State::Mutation
      include ActiveInteractor::State::Status
    end
  end
end
