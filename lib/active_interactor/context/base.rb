# frozen_string_literal: true

require 'ostruct'

module ActiveInteractor
  module Context
    class Base < OpenStruct
      include Action
      include Attribute
      include Status
      include Validation

      def initialize(interactor, hash = nil)
        super(hash)
        @interactor = interactor
      end

      def method_missing(name, *args, &block)
        interactor.send(name, *args, &block) if validation_callback?(name)
        super
      end

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
