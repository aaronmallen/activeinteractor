# frozen_string_literal: true

require 'active_model'
require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'

require_relative './attribute'
require_relative './attribute_set'
require_relative './type_validator'

module ActiveInteractor
  class Context
    module AttributeMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def _default_attributes
          @_default_attributes ||= AttributeSet.new({})
        end

        def attribute(*args)
          options = args.extract_options!
          attribute = Attribute.new(**{ name: args[0], type: args[1], description: args[2] }.merge(options))
          default_attribute_callbacks(attribute)
          _default_attributes[attribute.name] = attribute
        end

        def attribute?(attribute_name)
          _default_attributes.key?(attribute_name)
        end
        alias has_attribute? attribute?

        def attribute_names
          _default_attributes.keys
        end

        private

        def default_attribute_callbacks(attribute)
          validates_presence_of attribute.name if attribute.required?
          validate { |instance| TypeValidator.new(attribute).validate(instance) }
        end
      end

      def initialize(attributes = {})
        @attributes = self.class._default_attributes.deep_dup

        attributes.each do |name, value|
          @attributes.write_value(name, value)
        end
      end

      def [](name)
        @attributes.fetch_value(name)
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
        @attributes.keys
      end

      private

      def attribute_missing(attribute_name, *args)
        return unless attributes_respond_to_missing?(attribute_name)
        return @attributes.fetch_value(attribute_name) if @attributes.key?(attribute_name)

        attribute_setter_missing(attribute_name, *args)
      end

      def attributes_respond_to?(attribute_name)
        @attributes.key?(attribute_name)
      end

      def attributes_respond_to_missing?(attribute_name)
        attributes_respond_to?(attribute_name) || attributes_respond_to?(attribute_name[/.*(?==\z)/m])
      end

      def attribute_setter_missing(attribute_name, *args)
        attribute_key_name = attribute_name[/.*(?==\z)/m]
        return unless attribute_key_name

        if args.length != 1
          raise! ArgumentError, "wrong number of arguments (given #{args.length}, expected 1)", caller(1)
        end

        @attributes.write_value(attribute_key_name, args[0])
      end
    end

    include ActiveModel::Validations
    include AttributeMethods

    private

    def method_missing(method_name, *args, &block)
      return attribute_missing(method_name, *args) if attributes_respond_to_missing?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      return true if attributes_respond_to_missing?(method_name)

      super
    end
  end
end
