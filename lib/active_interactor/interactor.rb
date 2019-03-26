# frozen_string_literal: true

module ActiveInteractor
  # Provides interactor methods to included classes
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Interactor
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
      include Callbacks
      include Context
      attr_reader :context
    end
  end
end

Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }
