# frozen_string_literal: true

require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Context
    # Provides Context Attribute methods to included classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.4
    # @version 0.1
    module Attributes
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        class_attribute :__default_attributes, instance_writer: false, default: []
      end

      module ClassMethods
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
        #
        # @param attributes [Array<Symbol, String>] the attributes of the context
        #
        # @example Define attributes on a context class
        #  MyInteractor::Context.attributes = :first_name, :last_name
        #  #=> [:first_name, :last_name]
        #
        # @return [Array<Symbol>] the defined attributes
        def attributes=(*attributes)
          self.__default_attributes = self.attributes.concat(attributes.flatten.map(&:to_sym)).uniq
        end

        # Attribute aliases defined on the context class
        #
        # @example Get attribute aliases defined on a context class
        #  MyInteractor::Context.attribute_aliases
        #  #=> { last_name: [:sir_name] }
        #
        # @return [Hash{Symbol => Array<Symbol>}]
        def attribute_aliases
          @attribute_aliases ||= {}
        end

        # Set attribute aliases on the context class
        #
        # @param aliases [Hash{Symbol => Symbol, Array<Symbol>}] the attribute aliases of
        #  the context
        #
        # @return [Hash{Symbol => Array<Symbol>}]
        def alias_attributes(aliases = {})
          map_attribute_aliases(aliases)
          attribute_aliases
        end

        private

        def map_attribute_aliases(aliases)
          aliases.each_key do |attribute|
            key = attribute.to_sym
            attribute_aliases[key] ||= []
            attribute_aliases[key].concat(Array.wrap(aliases[attribute]).map(&:to_sym))
          end
        end
      end

      def initialize(attributes = {})
        super(map_attributes(attributes))
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
        return {} if keys.empty?

        clean_keys!
      end

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
        each_pair.map { |pair| pair[0].to_sym }
      end

      private

      def aliased_key(key)
        self.class.attribute_aliases.each_pair do |attribute, aliases|
          key = aliases.any? { |aliased| aliased == key.to_sym } ? attribute : key.to_sym
        end
        key
      end

      def clean_keys!
        keys.reject { |key| self.class.attributes.include?(key) }.each_with_object({}) do |attribute, deleted|
          deleted[attribute] = self[attribute] if self[attribute]
          delete_field(key.to_s)
        end
      end

      def map_attributes(attributes)
        return {} unless attributes

        attributes.keys.each_with_object({}) do |attribute, hash|
          key = aliased_key(attribute)
          hash[key] = attributes[attribute]
        end
      end

      def new_ostruct_member!(name)
        super(aliased_key(name))
      end
    end
  end
end
