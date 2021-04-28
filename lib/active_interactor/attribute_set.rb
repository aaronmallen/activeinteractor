# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/module'

module ActiveInteractor
  class AttributeSet
    delegate :key?, :keys, :values, to: :@attributes
    delegate :each, :each_with_object, to: :values

    def initialize(attributes)
      @attributes = attributes
    end

    def [](name)
      @attributes[name]
    end

    def []=(name, attribute)
      @attributes[name] = attribute
    end

    def deep_dup
      AttributeSet.new(@attributes.transform_values(&:dup))
    end

    def fetch_value(name)
      @attributes[name]&.value
    end

    def to_hash
      @attributes
        .select { |_name, attribute| attribute.initialized? }
        .transform_values(&:value)
    end
    alias to_h to_hash

    def write_value(name, value)
      @attributes[name]&.write_value(value)
    end
  end
end
