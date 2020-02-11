# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context error methods. Because {Errors} is a module classes should include {Errors} rather than
    # inherit from it.
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    module Errors
      # Generic errors generated outside of validation.
      #
      # @return [ActiveModel::Errors] an instance of `ActiveModel::Errors`
      def failure_errors
        @failure_errors ||= ActiveModel::Errors.new(self)
      end

      private

      def handle_errors(errors)
        if errors.is_a?(String)
          failure_errors.add(:context, errors)
        else
          failure_errors.merge!(errors)
        end
      end

      def merge_errors!(other)
        errors.merge!(other.errors)
        failure_errors.merge!(other.errors)
        failure_errors.merge!(other.failure_errors)
      end

      def resolve_errors
        errors.merge!(failure_errors)
      end
    end
  end
end
