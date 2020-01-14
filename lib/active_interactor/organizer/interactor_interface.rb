# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module ActiveInteractor
  class Organizer < ActiveInteractor::Base
    # @api private
    # An interface for an interactor's to allow conditional invokation of an
    #  interactor's {Interactor#perform #perform} method.
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @!attribute [r] filters
    #  @return [Hash{Symbol=>*}] conditional filters for an interactor's
    #    {Interactor#perform #perform} invocation.
    # @!attribute [r] interactor_class
    #  @return [Class] an interactor class
    # @!attribute [r] perform_options
    #  @return [Hash{Symbol=>*}] perform options to use for an interactor's
    #    {Interactor#perform #perform} invocation.
    class InteractorInterface
      attr_reader :filters, :interactor_class, :perform_options

      # @return [Array<Symbol>] keywords that indicate an option is a
      #  conditional.
      CONDITIONAL_FILTERS = %i[if unless].freeze

      # @param interactor_class [Class|Symbol|String] the {.interactor_class}
      # @param options [Hash{Symbol=>*}] the {.filters} and {.perform_options}
      # @return [InteractorInterface|nil] a new instance of {InteractorInterface} if
      #  the {#interactor_class} exists
      def initialize(interactor_class, options = {})
        @interactor_class = interactor_class.to_s.classify.safe_constantize
        @filters = options.select { |key, _value| CONDITIONAL_FILTERS.include?(key) }
        @perform_options = options.reject { |key, _value| CONDITIONAL_FILTERS.include?(key) }
      end

      # Check conditional filters on an interactor and invoke it's {Interactor#perform #perform}
      #  method if conditions are met.
      # @param target [Class] an instance of {Organizer}
      # @param context [Context::Base] the organizer's {Context::Base context} instance
      # @param fail_on_error [Boolean] if `true` {Interactor::Worker#perform! #perform!}
      #  will be invoked on the interactor. If `false` {Interactor::Worker#perform #perform}
      #  will be invokded on the interactor.
      # @param perform_options [Hash{Symbol=>*}] options for perform
      # @return [Context::Base|nil] an instance of {Context::Base} if an interactor's
      #   {Interactor#perform #perform} is invoked
      def perform(target, context, fail_on_error = false, perform_options = {})
        return if check_conditionals(target, filters[:if]) == false
        return if check_conditionals(target, filters[:unless]) == true

        method = fail_on_error ? :perform! : :perform
        options = self.perform_options.merge(perform_options)
        interactor_class.send(method, context, options)
      end

      private

      def check_conditionals(target, filter)
        return unless filter

        return target.send(filter) if filter.is_a?(Symbol)
        return target.instance_exec(&filter) if filter.is_a?(Proc)
      end
    end
  end
end
