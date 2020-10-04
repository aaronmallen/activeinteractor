# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # An interface object to facilitate conditionally calling {Interactor::Perform::ClassMethods#perform .perform} on
    # an {ActiveInteractor::Base interactor}
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    #
    # @!attribute [r] filters
    #  Conditional options for the {ActiveInteractor::Base interactor} class
    #
    #  @return [Hash{Symbol=>Proc, Symbol}] conditional options for the {ActiveInteractor::Base interactor} class
    #
    # @!attribute [r] interactor_class
    #  An {ActiveInteractor::Base interactor} class
    #
    #  @return [Const] an {ActiveInteractor::Base interactor} class
    #
    # @!attribute [r] perform_options
    #  {Interactor::Perform::Options} for the {ActiveInteractor::Base interactor} {Interactor::Perform#perform #perform}
    #
    #  @see Interactor::Perform::Options
    #
    #  @return [Hash{Symbol=>*}] {Interactor::Perform::Options} for the {ActiveInteractor::Base interactor}
    #   {Interactor::Perform#perform #perform}
    class InteractorInterface
      attr_reader :filters, :callbacks, :interactor_class, :perform_options

      # Keywords for conditional filters
      # @return [Array<Symbol>]
      CONDITIONAL_FILTERS = %i[if unless].freeze
      CALLBACKS = %i[before after].freeze

      # Initialize a new instance of {InteractorInterface}
      #
      # @param interactor_class [Const] an {ActiveInteractor::Base interactor} class
      # @param options [Hash] options to use for the {ActiveInteractor::Base interactor's}
      #  {Interactor::Perform::ClassMethods#perform .perform}. See {Interactor::Perform::Options}.
      # @return [InteractorInterface] a new instance of {InteractorInterface}
      def initialize(interactor_class, options = {})
        @interactor_class = interactor_class.to_s.camelize.safe_constantize
        @filters = options.select { |key, _value| CONDITIONAL_FILTERS.include?(key) }
        @callbacks = options.select { |key, _value| CALLBACKS.include?(key) }
        @perform_options = options.reject { |key, _value| CONDITIONAL_FILTERS.include?(key) || CALLBACKS.include?(key) }
      end

      # Call the {#interactor_class} {Interactor::Perform::ClassMethods#perform .perform} or
      # {Interactor::Perform::ClassMethods#perform! .perform!} method if all conditions in {#filters} are properly met.
      #
      # @param target [Class] the calling {Base organizer} instance
      # @param context [Class] an instance of {Context::Base context}
      # @param fail_on_error [Boolean] if `true` {Interactor::Perform::ClassMethods#perform! .perform!} will be called
      #  on the {#interactor_class} other wise {Interactor::Perform::ClassMethods#perform .perform} will be called.
      # @param perform_options [Hash] additional {Interactor::Perform::Options} to merge with {#perform_options}
      # @raise [Error::ContextFailure] if `fail_on_error` is `true` and the {#interactor_class}
      #  {Context::Status#fail! fails} its {Context::Base context}.
      # @return [Class] an instance of {Context::Base context}
      def perform(target, context, fail_on_error = false, perform_options = {})
        return if check_conditionals(target, :if) == false
        return if check_conditionals(target, :unless) == true

        method = fail_on_error ? :perform! : :perform
        options = self.perform_options.merge(perform_options)
        interactor_class.send(method, context, options)
      end

      def execute_inplace_callback(target, callback)
        resolve_option(target, callbacks[callback])
      end

      private

      def check_conditionals(target, filter)
        resolve_option(target, filters[filter])
      end

      def resolve_option(target, opt)
        return unless opt

        return target.send(opt) if opt.is_a?(Symbol)
        return target.instance_exec(&opt) if opt.is_a?(Proc)
      end
    end
  end
end
