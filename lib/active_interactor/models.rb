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
      def initialize(attributes = nil)
        copy_flags!(attributes) if attributes
        copy_called!(attributes) if attributes
        attributes_as_hash = context_attributes_as_hash(attributes)
        super(attributes_as_hash)
      end

      # Merge an instance of model class into the calling model class instance
      #
      # @see Context::Attributes#merge!
      #
      # @param context [Class] a {Base context} instance to be merged
      # @return [self] the {Base context} instance
      def merge!(context)
        copy_flags!(context)
        context.each_pair do |key, value|
          public_send("#{key}=", value) unless value.nil?
        end
        self
      end

      private

      def context_attributes_as_hash(attributes)
        return attributes.to_h if attributes&.respond_to?(:to_h)
        return attributes.attributes.to_h if attributes.respond_to?(:attributes)
      end
    end

    # Include methods needed for a {Context::Base context} class to function properly.
    #
    # @example
    #   class User
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

        include ActiveModel::Attributes
        include ActiveModel::Model
        include ActiveModel::Validations
        include ActiveInteractor::Context::Attributes
        include ActiveInteractor::Context::Status
        include ActiveInteractor::Models::InstanceMethods
        delegate :each_pair, to: :attributes
      end
    end
  end
end
