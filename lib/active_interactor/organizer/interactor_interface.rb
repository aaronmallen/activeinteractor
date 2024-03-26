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
    # @!attribute [r] callbacks
    #   Callbacks for the interactor_class
    #
    #   @since 1.1.0
    #
    #   @return [Hash{Symbol=>*}] the interactor callbacks
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
    #
    # @!attribute [r] deferred_after_perform_callbacks
    #   Deffered callbacks for the interactor_class
    #   @since 1.2.0
    #
    #   @return [Hash{Symbol=>*}] the interactor callbacks
    class InteractorInterface
      attr_reader :filters, :callbacks, :interactor_class, :perform_options, :deferred_after_perform_callbacks

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
        init_deferred_after_perform_callbacks
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

        skip_deferred_after_perform_callbacks

        method = fail_on_error ? :perform! : :perform
        options = self.perform_options.merge(perform_options)
        interactor_class.send(method, context, options)
      end

      def execute_inplace_callback(target, callback)
        resolve_option(target, callbacks[callback])
      end

      # Executes after_perform callbacks that have been deferred on the interactor
      def execute_deferred_after_perform_callbacks(context)
        return unless deferred_after_perform_callbacks.present?

        interactor = interactor_class.new(context)
        env = ActiveSupport::Callbacks::Filters::Environment.new(interactor, false, nil)
        deferred_after_perform_callbacks.compile.invoke_after(env)
        interactor.send(:context)
      end

      private

      def init_deferred_after_perform_callbacks
        after_callbacks_deferred = interactor_class.present? &&
                                   interactor_class.after_callbacks_deferred_when_organized
        @deferred_after_perform_callbacks = (after_perform_callbacks if after_callbacks_deferred)
      end

      def after_perform_callbacks
        result = interactor_class._perform_callbacks.clone

        interactor_class._perform_callbacks.each do |callback|
          next if callback.kind == :after && callback.name == :perform

          result.delete(callback)
        end

        result
      end

      def skip_deferred_after_perform_callbacks
        return unless deferred_after_perform_callbacks.present?

        deferred_after_perform_callbacks.each do |callback|
          interactor_class.skip_callback(:perform, :after, callback.filter, raise: false, if: -> { self.options.organizer.present? })
        end
      end

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
