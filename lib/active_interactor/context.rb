# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'
require 'ostruct'

module ActiveInteractor
  # ActiveInteractor::Context module
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Context
    # Raised when an interactor context fails
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    #
    # @!attribute [r] context
    #  @return [Base] an instance of {Base}
    class Failure < StandardError
      attr_reader :context

      # A new instance of {Failure}
      # @param context [Hash] an instance of {Base}
      # @return [Failure] a new instance of {Failure}
      def initialize(context = {})
        @context = context
        super
      end
    end

    # The base context class inherited by all {Interactor::Context} classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    class Base < OpenStruct
      include ActiveModel::Validations

      class_attribute :__default_attributes, instance_writer: false, default: []

      # A new instance of {Base}
      # @param interactor [ActiveInteractor::Base] an interactor instance
      # @param context [Hash, nil] the properties of the context
      # @return [ActiveInteractor::Context::Base] a new instance of {Base}
      def initialize(interactor, context = {})
        copy_flags!(context)
        @interactor = interactor
        super(context)
      end

      class << self
        # Attributes defined on the context class
        #
        # @example Get attributes defined on a context class
        #  MyInteractor::Context.attributes
        #  #=> [:first_name, :last_name]
        #
        # @return [Array<Symbol>] the defined attributes
        def attributes
          __default_attributes
            .concat(_validate_callbacks.map(&:filter).map(&:attributes).flatten)
            .flatten
            .uniq
        end

        # Set attributes on a context class
        # @param [Array<Symbol, String>] attributes
        #
        # @example Define attributes on a context class
        #  MyInteractor::Context.attributes = :first_name, :last_name
        #  #=> [:first_name, :last_name]
        #
        # @return [Array<Symbol>] the defined attributes
        def attributes=(*attributes)
          self.__default_attributes = self.attributes.concat(attributes.flatten.map(&:to_sym)).flatten.uniq
        end
      end

      # Attributes defined on the instance
      #
      # @example Get attributes defined on an instance
      #  MyInteractor::Context.attributes = :first_name, :last_name
      #  #=> [:first_name, :last_name]
      #
      #  context = MyInteractor::Context.new(first_name: 'Aaron', last_name: 'Allen')
      #  #=> <#MyInteractor::Context first_name='Aaron', last_name='Allen'>
      #
      #  context.attributes
      #  #=> { first_name: 'Aaron', last_name: 'Allen' }
      #
      # @example Get attributes defined on an instance with unknown attribute
      #  MyInteractor::Context.attributes = :first_name, :last_name
      #  #=> [:first_name, :last_name]
      #
      #  context = MyInteractor::Context.new(first_name: 'Aaron', last_name: 'Allen', unknown: 'unknown')
      #  #=> <#MyInteractor::Context first_name='Aaron', last_name='Allen', unknown='unknown'>
      #
      #  context.attributes
      #  #=> { first_name: 'Aaron', last_name: 'Allen' }
      #
      #  context.unknown
      #  #=> 'unknown'
      #
      # @return [Hash{Symbol => *}] the defined attributes and values
      def attributes
        self.class.attributes.each_with_object({}) do |attribute, hash|
          hash[attribute] = self[attribute] if self[attribute]
        end
      end

      # Track that an Interactor has been called. The {#called!} method
      #  is used by the interactor being invoked with this context. After an
      #  interactor is successfully called, the interactor instance is tracked in
      #  the context for the purpose of potential future rollback
      #
      # @param interactor [ActiveInteractor::Base] an interactor instance
      # @return [Array<ActiveInteractor::Base>] all called interactors
      def called!(interactor)
        _called << interactor
      end

      # Removes properties from the instance that are not
      # explicitly defined in the context instance {#attributes}
      #
      # @example Clean an instance of Context with unknown attribute
      #  MyInteractor::Context.attributes = :first_name, :last_name
      #  #=> [:first_name, :last_name]
      #
      #  context = MyInteractor::Context.new(first_name: 'Aaron', last_name: 'Allen', unknown: 'unknown')
      #  #=> <#MyInteractor::Context first_name='Aaron', last_name='Allen', unknown='unknown'>
      #
      #  context.unknown
      #  #=> 'unknown'
      #
      #  context.clean!
      #  #=> { unknown: 'unknown' }
      #
      #  context.unknown
      #  #=> nil
      #
      # @return [Hash{Symbol => *}] the deleted attributes
      def clean!
        deleted = {}
        keys.reject { |key| self.class.attributes.include?(key) }.each do |attribute|
          deleted[attribute] = self[attribute] if self[attribute]
          delete_field(key.to_s)
        end
        deleted
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

      # All keys of properties currently defined on the instance
      #
      # @example An instance of Context with unknown attribute
      #  MyInteractor::Context.attributes = :first_name, :last_name
      #  #=> [:first_name, :last_name]
      #
      #  context = MyInteractor::Context.new(first_name: 'Aaron', last_name: 'Allen', unknown: 'unknown')
      #  #=> <#MyInteractor::Context first_name='Aaron', last_name='Allen', unknown='unknown'>
      #
      #  context.keys
      #  #=> [:first_name, :last_name, :unknown]
      #
      # @return [Array<Symbol>] keys defined on the instance
      def keys
        each_pair { |pair| pair[0].to_sym }
      end

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
        !failure
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

  Dir[File.expand_path('context/*.rb', __dir__)].each { |file| require file }
end
