# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context attribute methods. Because {Attributes} is a module classes should include {Attributes} rather than
    # inherit from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.4
    module Attributes
      # Context attribute class methods. Because {ClassMethods} is a module classes should extend {ClassMethods} rather
      # than inherit from it.
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.1.4
      module ClassMethods
        # Get or set attributes on a {Base context} class
        #
        # @example Set attributes on a {Base context} class
        #   class MyContext < ActiveInteractor::Context::Base
        #     attributes :first_name, :last_name
        #   end
        #
        # @example Get attributes defined on a {Base context} class
        #   MyContext.attributes
        #   #=> [:first_name, :last_name]
        #
        # @example Set defaults for attributes on a {Base context} class
        #   class MyContext < ActiveInteractor::Context::Base
        #     attributes first_name: { default: -> { 'Aaron' } }, last_name: { default: -> { 'Allen' } }
        #   end
        #
        # @return [Array<Symbol>] the defined attributes
        def attributes(*attributes)
          attributes.compact.uniq.each { |attr| attribute(attr) }

          attribute_names.sort.collect(&:to_sym)
        end

        private

        def attribute?(attr_name)
          attribute_types.key?(attr_name.to_s)
        end
        alias has_attribute? attribute?
      end

      # Initialize a new instance of {Base}
      #
      # @param context [Hash, Base, Class] attributes to assign to the {Base context}
      # @return [Base] a new instance of {Base}
      def initialize(context = {})
        merge_errors!(context) if context.respond_to?(:errors)
        copy_flags!(context)
        copy_called!(context)
        context = context_attributes_as_hash(context) || {}
        super

        merge_attribute_values(context)
      end

      # Returns the value of an attribute
      #
      # @since 1.0.5
      #
      # @param name [String, Symbol] the key of the value to be returned
      # @returns [*] the attribute value
      def [](name)
        @table[name.to_sym] || attributes[name.to_sym]
      end

      # Sets value of a Hash attribute in context.attributes
      #
      # @since 1.1.0
      #
      # @param name [String, Symbol] the key name of the attribute
      # @param value [*] the value to be given attribute name
      # @returns [*] the attribute value
      def []=(name, value)
        public_send("#{name}=", value)

        super unless @table.nil?
      end

      # Get values defined on the instance of {Base context} whose keys are defined on the {Base context} class'
      # {ClassMethods#attributes .attributes}
      #
      # @example Get attributes defined on an instance of {Base context}
      #   class MyContext < ActiveInteractor::Context::Base
      #     attributes :first_name, :last_name
      #   end
      #
      #   context = MyContext.new(first_name: 'Aaron', last_name: 'Allen', occupation: 'Ruby Nerd')
      #   #=> <#MyContext first_name='Aaron' last_name='Allen' occupation='Ruby Nerd')
      #
      #   context.attributes
      #   #=> { first_name: 'Aaron', last_name: 'Allen' }
      #
      #   context.occupation
      #   #=> 'Ruby Nerd'
      #
      # @return [Hash{Symbol => *}] the defined attributes and values
      def attributes
        super.symbolize_keys
      end

      # Check if the {Base context} instance has an attribute
      #
      # @since 1.0.1
      #
      # @param attr_name [Symbol, String] the name of the attribute to check
      # @return [Boolean] whether or not the {Base context} instance has the attribute
      def attribute?(attr_name)
        @attributes.key?(attr_name.to_s)
      end
      alias has_attribute? attribute?

      # Merge an instance of {Base context} into the calling {Base context} instance
      #
      # @since 1.0.0
      #
      # @example
      #   context = MyContext.new(first_name: 'Aaron', last_name: 'Allen')
      #   other_context = MyContext.new(last_name: 'Awesome')
      #   context.merge!(other_context)
      #   #=> <#MyContext first_name='Aaron' last_name='Awesome'>
      #
      # @param context [Class] a {Base context} instance to be merged
      # @return [self] the {Base context} instance
      def merge!(context)
        merge_errors!(context) if context.respond_to?(:errors)
        copy_flags!(context)

        merged_context_attributes(context).each_pair do |key, value|
          self[key] = value unless value.nil?
        end
        self
      end

      private

      def _called
        @_called ||= []
      end

      def merged_context_attributes(context)
        attrs = {}
        attrs.merge!(context.to_h) if context.respond_to?(:to_h)
        attrs.merge!(context.attributes.to_h) if context.respond_to?(:attributes)
        attrs
      end

      def context_attributes_as_hash(context)
        return context.to_h if context&.respond_to?(:to_h)
        return context.attributes.to_h if context.respond_to?(:attributes)
      end

      def copy_called!(context)
        value = context.instance_variable_get('@_called') || []
        instance_variable_set('@_called', value)
      end

      def copy_flags!(context)
        %w[_failed _rolled_back].each do |flag|
          value = context.instance_variable_get("@#{flag}")
          instance_variable_set("@#{flag}", value)
        end
      end

      def merge_attribute_values(context)
        return unless context

        attributes.compact.merge(context).each_pair do |key, value|
          self[key] = value
        end
      end

      def is_method_protected!(name)
        return true if attribute?(name)

        super
      end
    end
  end
end
