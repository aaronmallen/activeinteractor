# frozen_string_literal: true

module ActiveInteractor
  module Rails
    # Model helper methods
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Models
      # Model class helper methods
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      module ClassMethods
        # Include {Context::Status} methods
        def acts_as_context
          class_eval do
            include InstanceMethods
            include ActiveInteractor::Context::Status
            delegate :each_pair, to: :attributes
          end
        end
      end

      # Model instance helper methods
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      module InstanceMethods
        # Override initialize method to ensure
        #  context flags are copied to the new instance
        # @param context [Hash|nil] attributes to assign to the class
        # @param options [Hash|nil] options for the class
        def initialize(context = nil, options = {})
          copy_flags!(context) if context
          copy_called!(context) if context
          attributes = context.to_h if context
          super(attributes, options)
        end

        # Merge an instance and ensure
        #  context flags are copied to the new instance
        # @param context [*] the instance to be merged
        # @return [*] the merged instance
        def merge!(context)
          copy_flags!(context)
          context.each_pair do |key, value|
            self[key] = value
          end
          self
        end
      end
    end
  end
end