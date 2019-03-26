# frozen_string_literal: true

require 'ostruct'

module ActiveInteractor
  module Context
    # The base context class inherited by all {Interactor::Context} classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    class Base < OpenStruct
      include ActiveModel::Validations
      include Action
      include Attribute
      include Status

      # A new instance of {Base}
      # @param interactor [#perform] an interactor instance
      # @param hash [Hash, nil] the properties of the context
      # @return [Context] a new instance of {Base}
      def initialize(interactor, hash = nil)
        super(hash)
        @interactor = interactor
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

      private

      attr_reader :interactor

      def validation_callback?(method_name)
        _validate_callbacks.map(&:filter).include?(method_name)
      end
    end
  end
end
