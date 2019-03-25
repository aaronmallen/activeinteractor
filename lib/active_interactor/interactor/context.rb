# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      extend ActiveSupport::Concern

      included do
        include AttributeAssignment
        include Delegation
        include Generation
        include Validation
      end
    end
  end
end

Dir[File.expand_path('context/*.rb', __dir__)].each { |file| require file }
