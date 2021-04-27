# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module ActiveInteractor
  class Attribute
    NO_DEFAULT = :__no_default__

    attr_reader :default_value, :description, :name

    def initialize(name:, type:, default_value: NO_DEFAULT, description: nil, required: false)
      @name = name.to_sym
      @type_expression = type
      @default_value = default_value || NO_DEFAULT
      @description = description
      @required = required
    end

    def initialized?
      @assigned_value || default_value? || false
    end

    def required?
      @required || false
    end

    def type
      @type = case @type_expression
              when String
                @type_expression.constantize
              else
                @type_expression
              end
    end

    def value
      resolve_value
    end

    def write_value(value)
      @assigned_value = true
      @value = value
    end

    private

    def default_value?
      @default_value != NO_DEFAULT
    end

    def resolve_value
      return @value if @assigned_value
      return default_value if default_value?
    end
  end
end
