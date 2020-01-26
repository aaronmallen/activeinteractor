# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Interactor perform methods. Because {Perform} is a module classes should include {Perform} rather than inherit
    # from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Perform
      # Interactor perform class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      module ClassMethods
        # Initialize a new {Base interactor} instance and call its {Interactor::Perform#perform #perform} method. This
        # is the default api to interact with all {Base interactors}.
        #
        # @since 0.1.0
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     def perform
        #       puts "I performed"
        #     end
        #   end
        #
        #   MyInteractor.perform
        #   "I performed"
        #   #=> <#MyInteractor::Context>
        #
        # @param context [Hash, Class] attributes to assign to the {Base interactor} instance's
        #  {ActiveInteractor::Context::Base context} instance
        # @param options [Hash, Perform::Options] options to use for the {.perform}. See {Perform::Options}
        # @return [Class] an instance of the {Base interactor} class' {ActiveInteractor::Context::Base context}
        #  instance
        def perform(context = {}, options = {})
          new(context).with_options(options).execute_perform
        end

        # Initialize a new {Base interactor} instance and call its {Interactor::Perform#perform #perform} method without
        # rescuing {ActiveInteractor::Error::ContextFailure}.
        #
        # @since 0.1.0
        #
        # @example Calling {Perform::ClassMethods#perform! .perform!} without failure
        #   class MyInteractor < ActiveInteractor::Base
        #     def perform
        #       puts "I performed"
        #     end
        #   end
        #
        #   MyInteractor.perform!
        #   "I performed"
        #   #=> <#MyInteractor::Context>
        #
        # @example Calling {Perform::ClassMethods#perform! .perform!} with failure
        #   class MyInteractor < ActiveInteractor::Base
        #     def perform
        #       context.fail!
        #     end
        #   end
        #
        #   MyInteractor.perform!
        #   ActiveInteractor::Error::ContextFailure "<#MyInteractor::Context>"
        #
        # @param context [Hash, Class] attributes to assign to the {Base interactor} instance's
        #  {ActiveInteractor::Context::Base context} instance
        # @param options [Hash, Perform::Options] options to use for the {.perform}. See {Perform::Options}
        # @raise [Error::ContextFailure] if the {ActiveInteractor::Context::Base context} instance
        #  fails.
        # @return [Class] an instance of the {Base interactor} class' {ActiveInteractor::Context::Base context}
        #  instance
        def perform!(context = {}, options = {})
          new(context).with_options(options).execute_perform!
        end
      end

      # Interactor {Interactor::Perform#perform #perform} options
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      #
      # @!attribute [rw] skip_each_perform_callbacks
      #  if `true` an {Organizer::Base organizer} will be instructed to skip
      #  {Organizer::Callbacks::ClassMethods each_perform} callbacks.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or not to skip {Organizer::Callbacks::ClassMethods each_perform} callbacks
      #
      # @!attribute [rw] skip_perform_callbacks
      #  if `true` an {Base interactor} will be instructed to skip {Interactor::Callbacks::ClassMethods perform}
      #  callbacks.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or not to skip {Interactor::Callbacks::ClassMethods perform} callbacks.
      #
      # @!attribute [rw] skip_rollback
      #  if `true` an {Base interactor} will be instructed to skip {Interactor::Perform#rollback #rollback} on
      #  {Context::Base context} {ActiveInteractor::Context::Status#fail! failure}.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or not to skip {Interactor::Perform#rollback #rollback}
      #
      # @!attribute [rw] skip_rollback_callbacks
      #  if `true` an {Base interactor} will be instructed to skip {Interactor::Callbacks::ClassMethods rollback}
      #  callbacks on {Context::Base context} {ActiveInteractor::Context::Status#fail! failure}.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or not to skip {Interactor::Callbacks::ClassMethods rollback} callbacks.
      #
      # @!attribute [rw] validate
      #  if `false` an {Base interactor} will not run validations.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or to run validations.
      #
      # @!attribute [rw] validate_on_calling
      #  if `false` an {Base interactor} will not run validations with the validation context `:calling`.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or to run validations with the validation context `:calling`
      #
      # @!attribute [rw] validate_on_called
      #  if `false` an {Base interactor} will not run validations with the validation context `:called`.
      #
      #  @since 1.0.0
      #
      #  @return [Boolean] whether or to run validation with the validation context `:called`.
      #
      # @!method initialize(options = {})
      #  Initialize a new instance of {Options}
      #
      #  @since 1.0.0
      #
      #  @param options [Hash{Symbol=>*}] the attributes to assign to {Options}
      #  @option options [Boolean] :skip_each_perform_callbacks (false) the {Options#skip_each_perform_callbacks}
      #   attribute
      #  @option options [Boolean] :skip_perform_callbacks (false) the {Options#skip_perform_callbacks} attribute
      #  @option options [Boolean] :skip_rollback (false) the {Options#skip_rollback} attribute
      #  @option options [Boolean] :skip_rollback_callbacks (false) the {Options#skip_rollback_callbacks} attribute
      #  @option options [Boolean] :validate (true) the {Options#validate} attribute
      #  @option options [Boolean] :validate_on_calling (true) the {Options#validate_on_calling} attribute
      #  @option options [Boolean] :validate_on_called (true) the {Options#validate_on_called} attribute
      #  @return [Options] a new instance of {Options}
      class Options
        include ActiveInteractor::Configurable
        defaults skip_each_perform_callbacks: false, skip_perform_callbacks: false, skip_rollback: false,
                 skip_rollback_callbacks: false, validate: true, validate_on_calling: true, validate_on_called: true
      end

      # @!method execute_perform
      #  Run the {Base interactor} instance's {#perform} with callbacks and validation.
      #
      #  @api private
      #  @since 0.1.0
      #
      # @!method execute_perform!
      #  Run the {Base interactor} instance's {#perform} with callbacks and validation without rescuing
      #  {Error::ContextFailure}.
      #
      #  @api private
      #  @since 0.1.0
      delegate :execute_perform, :execute_perform!, to: :worker

      # Duplicate an {Base interactor} instance as well as it's {#options} and {ActiveInteractor::Context::Base context}
      # instances.
      #
      # @return [Base] a duplicated {Base interactor} instance
      def deep_dup
        self.class.new(context.dup).with_options(options.dup)
      end

      # Options for the {Base interactor} {#perform}
      #
      # @return [Options] an instance of {Options}
      def options
        @options ||= ActiveInteractor::Interactor::Perform::Options.new
      end

      # The steps to run when an {Base interactor} is called. An {Base interactor's} {#perform} method should never be
      # called directly on an {Base interactor} instance and should instead be invoked by the {Base interactor's} class
      # method {Perform::ClassMethods#perform .perform}.
      #
      # @since 0.1.0
      #
      # @abstract {Base interactors} should override {#perform} with the appropriate steps and
      #  {ActiveInteractor::Context::Base context} mutations required for the {Base interactor} to do its work.
      #
      # @example
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform
      #       context.first_name = 'Aaron'
      #     end
      #   end
      #
      #   MyInteractor.perform
      #   #=> <#MyInteractor::Context first_name='Aaron'>
      def perform; end

      # The steps to run when an {Base interactor} {ActiveInteractor::Context::Status#fail! fails}. An
      # {Base interactor's} {#rollback} method should never be called directly and is instead called by the
      # {Base interactor's} {ActiveInteractor::Context::Base context} when
      # {ActiveInteractor::Context::Status#fail! #fail} is called.
      #
      # @since 0.1.0
      #
      # @abstract {Base interactors} should override {#rollback} with the appropriate steps and
      #  {ActiveInteractor::Context::Base context} mutations required for the {Base interactor} to roll back its work.
      #
      # @example
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform
      #       context.first_name = 'Aaron'
      #       context.fail!
      #     end
      #
      #     def rollback
      #       context.first_name = 'Bob'
      #     end
      #   end
      #
      #   MyInteractor.perform
      #   #=> <#MyInteractor::Context first_name='Bob'>
      def rollback; end

      # Set {Options options} for an {Base interactor's} {#perform}
      #
      # @api private
      #
      # @param options [Hash, Perform::Options] options to use for the perform call. See {Perform::Options}
      # @return [self] the {Base interactor} instance
      def with_options(options)
        @options = if options.is_a?(ActiveInteractor::Interactor::Perform::Options)
                     options
                   else
                     ActiveInteractor::Interactor::Perform::Options.new(options)
                   end
        self
      end

      private

      def worker
        ActiveInteractor::Interactor::Worker.new(self)
      end
    end
  end
end
