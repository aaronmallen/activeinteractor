# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # An Interactor Result object.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    #
    # @!attribute [r] context
    #  The {ActiveInteractor::Context::Base context} object
    #  @return [ActiveInteractor::Context::Base] the context object
    #
    # @!attribute [r] state
    #  The {ActiveInteractor::Interactor::State state} object
    #  @return [ActiveInteractor::Interactor::State] the state object
    class Result
      attr_reader :context, :state

      # @!method errors
      #  @see ActiveInteractor::Context::Base#errors
      delegate :errors, to: :context

      # @!method called
      #  @see ActiveInteractor::Interactor::State#called
      #
      # @!method called!(interactor)
      #  @see ActiveInteractor::Interactor::State#called!
      #
      # @!method fail?
      #  @see ActiveInteractor::Interactor::State#fail?
      #
      # @!method failure?
      #  @see ActiveInteractor::Interactor::State#fail?
      #
      # @!method success?
      #  @see ActiveInteractor::Interactor::State#success?
      #
      # @!method successful?
      #  @see ActiveInteractor::Interactor::State#success?
      delegate :called, :called!, :fail?, :failure?, :success?, :successful?, to: :state

      # Initializes a new instance of {Result}
      #
      # @param context [ActiveInteractor::Context::Base] a {ActiveInteractor::Context::Base context} instance
      # @param state [ActiveInteractor::Interactor::State, nil] a {ActiveInteractor::Interactor::State state} instance
      # @return [Result] a new instance of {Result}
      def initialize(context, state = nil)
        @context = context
        @state = state || State.new
      end

      # Fail the {Result} instance.  Failing an instance raises an error that may be rescued by the calling
      # {ActiveInteractor::Base interactor}.  The {#state} instance is also flagged as failed
      #
      # @param errors [String, ActiveModel::Errors, Hash, Array<String, ActiveModel::Errors, Hash>] error messages
      #  for the failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @raise [Error::ContextFailure]
      def fail!(errors = nil)
        handle_errors(errors)
        resolve_errors!
        state.fail!
        raise ActiveInteractor::Error::ContextFailure, self
      end

      # Rollback {ActiveInteractor::Base interactors}. Any {ActiveInteractor::Base interactors} listed in {#state}
      # {ActiveInteractor::Interactor::State#called #called} are asked to roll themselves back by invoking thier
      # {ActiveInteractor::Base#rollback #rollback} methods.  The {ActiveInteractor::Base interactor} instance
      # is also added to {#state} {ActiveInteractor::Interactor::State#rolled_back #rolled_back} list.
      #
      # @return [Boolean] `true` if all {ActiveInteractor::Interactor::State#called #called} interactors have
      #  successfully rolled back otherwise `false`.
      def rollback!
        rollback_called!
        (state.rolled_back - state.called).empty?
      end

      private

      def handle_errors(errors)
        case errors
        when String
          context.errors.add(:context, errors)
        when ActiveModel::Errors
          context.errors.merge!(errors)
        when Hash
          handle_hashed_errors(errors)
        when Array
          handle_listed_errors(errors)
        end
      end

      def handle_hashed_errors(errors)
        errors.each do |attr, error|
          context.errors.add(attr, error)
        end
      end

      def handle_listed_errors(errors)
        errors.each { |error| handle_errors(error) }
      end

      def method_missing(method_name, *args, &block)
        result = context.public_send(method_name, *args, &block)
        ActiveInteractor::Deprecation::V2.deprecation_warning(
          method_name,
          'calling #context methods on an ActiveInteractor::Interactor::Result is deprecated use #context instead',
          caller
        )
        result
      rescue NoMethodError
        super
      end

      if ActiveModel::Errors.method_defined?(:import)
        def resolve_errors!
          all_errors = context.errors.uniq.compact
          context.errors.clear
          all_errors.each { |error| context.errors.import(error) }
        end
      else
        def resolve_errors!
          all_errors = context.errors.uniq.compact
          context.errors.clear
          all_errors.each { |error| context.errors.add(error[0], error[1]) }
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        return true if method_name[/.*(?==\z)/m]

        context.respond_to?(method_name, include_private) || super
      end

      def rollback_called!
        state.called.reverse_each do |interactor|
          next if state.rolled_back.include? interactor

          interactor.rollback
          state.rolled_back! interactor
        end
      end
    end
  end
end
