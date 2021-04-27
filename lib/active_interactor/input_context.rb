# frozen_string_literal: true

require_relative './context'

module ActiveInteractor
  class InputContext < Context
    class << self
      alias argument attribute
    end
  end
end
