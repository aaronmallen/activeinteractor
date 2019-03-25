# frozen_string_literal: true

module ActiveInteractor
  module Context
    module Validation
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations
      end
    end
  end
end
