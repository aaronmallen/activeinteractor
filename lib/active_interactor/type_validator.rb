# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module ActiveInteractor
  class TypeValidator
    def initialize(attribute)
      @attribute = attribute
    end

    def validate(object)
      value = object.send(@attribute.name)
      return if value.blank?
      return if value.is_a?(@attribute.type)

      object.errors.add(@attribute.name, "must be a #{@attribute.type}")
    end
  end
end
