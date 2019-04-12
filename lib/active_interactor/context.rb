# frozen_string_literal: true

require 'ostruct'

Dir[File.expand_path('context/*.rb', __dir__)].each { |file| require file }

module ActiveInteractor
  # ActiveInteractor::Context module
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Context
    # The base context class inherited by all {Interactor::Context} classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.2
    class Base < OpenStruct
      include ActiveModel::Validations
      include Attributes

      # A new instance of {Base}
      # @param interactor [ActiveInteractor::Base] an interactor instance
      # @param attributes [Hash, nil] the attributes of the context
      # @return [ActiveInteractor::Context::Base] a new instance of {Base}
      def initialize(interactor, attributes = {})
        copy_flags!(attributes)
        @interactor = interactor
        super(attributes)
      end

      # Track that an Interactor has been called. The {#called!} method
      #  is used by the interactor being invoked with this context. After an
      #  interactor is successfully called, the interactor instance is tracked in
      #  the context for the purpose of potential future rollback
      #
      # @return [Array<ActiveInteractor::Base>] all called interactors
      def called!
        _called << interactor
      end

      # Fail the context instance. Failing a context raises an error
      #  that may be rescued by the calling interactor. The context is also flagged
      #  as having failed
      #
      # @example Fail an interactor context
      #  interactor = MyInteractor.new(name: 'Aaron')
      #  #=> <#MyInteractor name='Aaron'>
      #
      #  interactor.context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context name='Aaron'>
      #
      # @param errors [ActiveModel::Errors, Hash] errors to add to the context on failure
      # @see https://api.rubyonrails.org/classes/ActiveModel/Errors.html ActiveModel::Errors
      # @raise [Failure]
      def fail!(errors = {})
        self.errors.merge!(errors) unless errors.empty?
        @_failed = true
        raise Failure, self
      end

      # Whether the context instance has failed. By default, a new
      # context is successful and only changes when explicitly failed
      #
      # @note The {#failure?} method is the inverse of the {#success?} method
      #
      # @example Check if a context has failed
      #  context = MyInteractor::Context.new
      #  #=> <#MyInteractor::Context>
      #
      #  context.failure?
      #  false
      #
      #  context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context>
      #
      #  context.failure?
      #  #=> true
      #
      # @return [Boolean] `false` by default or `true` if failed
      def failure?
        @_failed || false
      end
      alias fail? failure?

      # Attempt to call the interactor for missing validation callback methods
      # @raise [NameError] if the method is not a validation callback or method
      #  does not exist on the interactor instance
      def method_missing(name, *args, &block)
        interactor.send(name, *args, &block) if validation_callback?(name)
        super
      end

      # Attempt to call the interactor for missing validation callback methods
      # @return [Boolean] `true` if method is a validation callback and exists
      #  on the interactor instance
      def respond_to_missing?(name, include_private)
        return false unless validation_callback?(name)

        interactor.respond_to?(name, include_private)
      end

      # Roll back an interactor context. Any interactors to which this
      # context has been passed and which have been successfully called are asked
      # to roll themselves back by invoking their
      # {ActiveInteractor::Interactor#rollback #rollback} instance methods.
      #
      # @example Rollback an interactor's context
      #  context = MyInteractor.perform(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      #  context.rollback!
      #  #=> true
      #
      #  context
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      # @return [Boolean] `true` if rolled back successfully or `false` if already
      #  rolled back
      def rollback!
        return false if @_rolled_back

        _called.reverse_each(&:execute_rollback)
        @_rolled_back = true
      end

      # Whether the context instance is successful. By default, a new
      # context is successful and only changes when explicitly failed
      #
      # @note the {#success?} method is the inverse of the {#failure?} method
      #
      # @example Check if a context has failed
      #  context = MyInteractor::Context.new
      #  #=> <#MyInteractor::Context>
      #
      #  context.success?
      #  true
      #
      #  context.fail!
      #  #=> ActiveInteractor::Context::Failure: <#MyInteractor::Context>
      #
      #  context.success?
      #  #=> false
      #
      # @return [Boolean] `true` by default or `false` if failed
      def success?
        !failure?
      end
      alias successful? success?

      private

      attr_reader :interactor

      def copy_flags!(context)
        @_called = context.send(:_called) if context.respond_to?(:_called, true)
        @_failed = context.failure? if context.respond_to?(:failure?)
      end

      def _called
        @_called ||= []
      end

      def validation_callback?(method_name)
        _validate_callbacks.map(&:filter).include?(method_name)
      end
    end
  end
end
