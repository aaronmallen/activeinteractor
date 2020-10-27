# frozen_string_literal: true

module ActiveInteractor
  # Helper methods for using classes that do not inherit from {Context::Base} as {Context::Base context} objects
  # for {Base interactors}.  Classes should extend {Models}.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  module Models
    # Instance methods needed for a {Context::Base context} class to function properly.
    #
    # @private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module InstanceMethods
      def initialize(*)
        @attributes = self.class._default_attributes&.deep_dup
        super
      end
    end

    # Include methods needed for a {Context::Base context} class to function properly.
    #
    # @note You must include ActiveModel::Model and ActiveModel::Attributes or a similar implementation for
    #  the object to function properly.
    #
    # @example
    #   class User
    #     include ActiveModel::Model
    #     include ActiveModel::Attributes
    #     extend ActiveInteractor::Models
    #     acts_as_context
    #   end
    #
    #   class MyInteractor < ActiveInteractor::Base
    #     contextualize_with :user
    #   end
    def acts_as_context
      class_eval do
        extend ActiveInteractor::Context::Attributes::ClassMethods

        include ActiveInteractor::Context::Attributes
        include ActiveInteractor::Context::Errors
        include ActiveInteractor::Models::InstanceMethods
        delegate :each_pair, to: :attributes
      end
    end
  end
end
