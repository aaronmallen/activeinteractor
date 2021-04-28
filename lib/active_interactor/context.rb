# frozen_string_literal: true

require 'active_model'
require 'active_support/concern'

require_relative './attribute_set'

module ActiveInteractor
  class Context
    module AttributeMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def _default_attributes
          @_default_attributes ||= AttributeSet.new
        end

        def attribute(*attribute_options)
          _default_attributes.add(*attribute_options)
        end

        def attribute?(attribute_name)
          _default_attributes.attribute?(attribute_name)
        end
        alias has_attribute? attribute?

        def attribute_names
          _default_attributes.attribute_names
        end
      end

      def initialize(attributes = {})
        @attributes = self.class._default_attributes.deep_dup

        attributes.each { |name, value| @attributes.write_value(name, value) }
      end

      def [](name)
        @attributes.get_value(name)
      end

      def []=(name, value)
        @attributes.write_value(name, value)
      end

      def attributes
        @attributes.to_hash
      end

      def attribute?(attribute_name)
        attributes_respond_to?(attribute_name)
      end
      alias has_attribute? attribute?

      def attribute_names
        @attributes.attribute_names
      end

      private

      def attribute_missing(attribute_name, *args)
        return unless attributes_respond_to_missing?(attribute_name)
        return @attributes.get_value(attribute_name) if @attributes.attribute?(attribute_name)

        attribute_setter_missing(attribute_name, *args)
      end

      def attributes_respond_to?(attribute_name)
        @attributes.attribute?(attribute_name)
      end

      def attributes_respond_to_missing?(attribute_name)
        attributes_respond_to?(attribute_name) || attributes_respond_to?(attribute_name[/.*(?==\z)/m])
      end

      def attribute_setter_missing(attribute_name, *args)
        attribute_key_name = attribute_name[/.*(?==\z)/m]

        if args.length != 1
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 1)", caller(1)
        end

        @attributes.write_value(attribute_key_name, args[0])
      end
    end

    include ActiveModel::Validations
    include AttributeMethods

    private

    def method_missing(method_name, *args, &block)
      attribute_missing(method_name, *args) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      return true if attributes_respond_to_missing?(method_name)

      super
    end
  end
end
