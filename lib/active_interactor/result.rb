# frozen_string_literal: true

module ActiveInteractor
  # An interactor result object.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since unreleased
  class Result
    # Initialize a new instance of {Result}
    #
    # @param interactor [Base] an {Base interactor} instance
    # @return [Result] a new instance of {Result}
    def initialize(interactor)
      @interactor = interactor
    end

    # The {Context::Base context} instance of the {Base interactor} instance
    #
    # @return [Context::Base] the {Context::Base context} instance
    def context
      @context ||= interactor.finalize_context!
    end

    # {Result} errors
    #
    # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
    # @return [ActiveModel::Errors] an instance of
    #  {https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors}
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Validate the {Context::Base context} instance, merge {State} and {Context::Base context} errors
    # and {State#fail! #fail!} the {State} instance if the {Result} has any errors.
    #
    # @return [self] the {Result} instance
    def resolve
      resolve_context_and_state
      self
    end

    # The {State} instance of the {Base interactor} instance
    #
    # @return [State] the {State} instance
    def state
      @state ||= interactor.state
    end

    private

    attr_reader :interactor

    def resolve_context
      context.valid? if interactor.options.validate
    end

    def resolve_context_and_state
      resolve_context
      resolve_errors
      resolve_state
    end

    def resolve_errors
      errors.clear
      all_errors = (context.errors.uniq + state.errors.uniq).uniq
      all_errors.each { |error| errors.add(*error) }
    end

    def resolve_state
      resolve_errors
      state.called!(interactor)
      state.fail! unless errors.empty?
    end
  end
end
