# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Context
    # Provides context attribute methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Attribute
      extend ActiveSupport::Concern

      included do
        class_attribute :__default_attributes, instance_writer: false, default: []
      end

      class_methods do
        # Attributes defined on the context class
        #
        # @example Get attributes defined on a context class
        #  MyInteractor::Context.attributes
        #  #=> [:first_name, :last_name]
        #
        # @return [Array<Symbol>] the defined attributes
        def attributes
          __default_attributes
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
          __default_attributes.concat(attributes.flatten.map(&:to_sym)).flatten.uniq
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
    end
  end
end
