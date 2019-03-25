# frozen_string_literal: true

require 'ostruct'

module ActiveInteractor
  module Context
    class Base < OpenStruct
      include Action
      include Attribute
      include Status
      include Validation
    end
  end
end
