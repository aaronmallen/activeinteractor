# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/module'

require_relative './attribute'

module ActiveInteractor
  class AttributeSet
    delegate :empty?, to: :@attributes

    def initialize(*attributes)
      @attributes = attributes.each_with_object({}) do |attribute, hash|
        next unless attribute.is_a?(Attribute)

        hash[attribute.name] = attribute
      end
    end

    def add(*attribute_options)
      attribute = Attribute.new(**extract_attribute_options!(attribute_options))
      @attributes[attribute.name] = attribute
    end

    def attribute?(name)
      @attributes.key?(name)
    end

    def attribute_names
      @attributes.keys
    end

    def clear!
      @attributes = {}
      self
    end

    def deep_dup
      AttributeSet.new(*@attributes.transform_values(&:dup).values)
    end

    def get_attribute(name)
      @attributes[name]
    end
    alias [] get_attribute

    def get_value(name)
      get_attribute(name)&.value
    end

    def to_hash
      @attributes
        .select { |_, attribute| attribute.initialized? }
        .transform_values(&:value)
    end
    alias to_h to_hash

    def write_value(name, value)
      get_attribute(name)&.write_value(value)
    end

    private

    def extract_attribute_options!(attribute_options)
      options = attribute_options.extract_options!
      name, type, description = attribute_options
      { name: name, type: type, description: description }.merge(options)
    end
  end
end
