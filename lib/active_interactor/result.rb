# frozen_string_literal: true

module ActiveInteractor
  # An {Base interactor} result object.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since unreleased
  #
  # @!attribute [r] context
  #  @return [Context::Base] an instance of {Context::Base context}
  # @!attribute [r] interactor
  #  @return [Base] an instance of {Base interactor}
  # @!attribute [r] state
  #  @return [State::Manager] an instance of {State::Manager state}
  class Result
    attr_reader :context, :interactor, :state

    # Initialize a new instance of {Result}
    #
    # @param interactor [Base] the {Base interactor} instance
    # @param state [State::Manager] the {State::Manager state} instance
    # @return [Result] a new instance of {Result}
    def initialize(interactor, state)
      @interactor = interactor
      @state = state
    end

    # Result errors
    #
    # @return [ActiveModel::Errors] an instance of
    #  {https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors}
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Whether the {State::Manager state} instance has {State::Mutation#fail! failed} or the {Context::Base context}
    #  instance has {Context::Status#fail! failed}.
    #
    # @deprecated Use {State::Manager#fail?} instead
    #
    # @return [Boolean] `false` by default or `true` if {State::Mutation#fail! failed}.
    def fail?
      state_method_deprecation_warning(:fail?)
      failure_without_warn?
    end

    # Whether the {State::Manager state} instance has {State::Mutation#fail! failed} or the {Context::Base context}
    #  instance has {Context::Status#fail! failed}.
    #
    # @deprecated Use {State::Manager#failure?} instead
    #
    # @return [Boolean] `false` by default or `true` if {State::Mutation#fail! failed}.
    def failure?
      state_method_deprecation_warning(:failure?)
      failure_without_warn?
    end

    # @private
    def failure_without_warn?
      state.failure? || context&.failure? || false
    end

    # @private
    def method_missing(method, *args, &block)
      return super unless context.respond_to?(method)

      context_method_deprecation_warning(method)
      context.send(method, *args, &block)
    end

    # Merge {Context::Base context} and {State::Manager state} errors and validate the {Context::Base context} instance
    #
    # @return [self] the {Result} instance
    def resolve
      resolve_context
      resolve_errors
      resolve_status
      self
    end

    # @private
    def respond_to_missing?(method, include_private = false)
      return super unless context.respond_to?(method, include_private)

      context_method_deprecation_warning(method)
      context.respond_to?(method, include_private)
    end

    # Whether the {State::Manager state} instance and {Context::Base context} instance is successful.
    #
    # @deprecated Use {State::Manager#success?} instead
    #
    # @return [Boolean] `true` by default or `false` if {State::Mutation#fail! failed}
    def success?
      state_method_deprecation_warning(:success?)
      success_without_warn?
    end

    # Whether the {State::Manager state} instance and {Context::Base context} instance is successful.
    #
    # @deprecated Use {State::Manager#successful?} instead
    #
    # @return [Boolean] `true` by default or `false` if {State::Mutation#fail! failed}
    def successful?
      state_method_deprecation_warning(:successful?)
      success_without_warn?
    end

    # @private
    def success_without_warn?
      state.success? && (context.nil? ? true : context.success?)
    end

    private

    def collected_errors
      (state.errors.uniq + context.errors.uniq).compact.uniq
    end

    def component_method_deprecation_warning(component, method)
      ActiveInteractor::NextMajorDeprecator.deprecation_warning(
        "calling #{component} methods on an ActiveInteractor::Result",
        "use result.#{component}.#{method} instead"
      )
    end

    def context_method_deprecation_warning(method)
      component_method_deprecation_warning(:context, method)
    end

    def resolve_context
      @context = interactor.finalize_context!
      context.valid? if interactor.options.validate
    end

    def resolve_errors
      return if collected_errors.empty?

      errors.clear
      collected_errors.each { |error| errors.add(*error) }
    end

    def resolve_status
      return if errors.empty?

      state.fail!(errors)
      resolve_errors
    end

    def state_method_deprecation_warning(method)
      component_method_deprecation_warning(:state, method)
    end
  end
end
