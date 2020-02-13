# frozen_string_literal: true

module ActiveInteractor
  module State
    # State mutation methods. Because {Mutation} is a module classes should include {Mutation} rather than inherit from
    # it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    #
    # @!attribute [r] errors
    #  @return [ActiveModel::Errors] an instance of
    #   {https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors}
    module Mutation
      attr_reader :errors

      # Initiailize a new instance of {Manager}
      #
      # @return [Manager] a new instance of {Manager}
      def initialize
        @errors = ActiveModel::Errors.new(self)
      end

      # Add an instance of {ActiveInteractor::Base interactor} to the list of {ActiveInteractor::Base interactors}
      # called on the {Manager state}. This list is used when {Mutation#rollback!} is called on a {Manager state}
      # instance.
      #
      # @param interactor [#rollback] an {ActiveInteractor::Base interactor} instance
      # @return [self] the {Manager state} instance.
      def called!(interactor)
        return self unless interactor.respond_to?(:rollback)

        _called << interactor
        self
      end

      # Fail the {Manager state} instance. The instance is flagged as having failed.
      #
      # @param errors [ActiveModel::Errors, String] error messages for the failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @return [self] the {Manager state} instance.
      def fail!(errors = nil)
        handle_errors(errors) if errors
        @_failed = true
        self
      end

      # {#rollback! Rollback} an instance of {Manager state}. Any {ActiveInteractor::Base interactors} the instance has
      # been passed via the {#called!} method are asked to roll themselves back by invoking their
      # {Interactor::Perform#rollback #rollback} methods. The instance is also flagged as rolled back.
      #
      # @return [self] the {Manager state} instance.
      def rollback!
        return self if rolled_back?

        _called.reverse_each(&:rollback)
        @_rolled_back = true
        self
      end

      private

      def _called
        @_called ||= []
      end

      def handle_errors(errors)
        if errors.is_a?(String)
          self.errors.add(:interactor, errors)
        else
          self.errors.merge!(errors)
        end
      end
    end
  end
end
