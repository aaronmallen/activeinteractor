# frozen_string_literal: true

require_relative './context'

module ActiveInteractor
  class OutputContext < Context
    class << self
      alias returns attribute
    end
  end
end
