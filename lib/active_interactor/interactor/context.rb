# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides ActiveInteractor::Interactor::Context methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
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
