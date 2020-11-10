# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context error methods. Because {Errors} is a module classes should include {Errors} rather than
    # inherit from it.
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.3
    module Errors
      # Generic errors generated outside of validation.
      #
      # @return [ActiveModel::Errors] an instance of `ActiveModel::Errors`
      def failure_errors
        @failure_errors ||= ActiveModel::Errors.new(self)
      end

      private

      def add_errors(errors)
        errors.each do |error|
          if self.errors.respond_to?(:import)
            self.errors.import(error)
          else
            self.errors.add(error[0], error[1])
          end
        end
      end

      def clear_all_errors
        errors.clear
        failure_errors.clear
      end

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
        all_errors = (failure_errors.uniq + errors.uniq).compact.uniq
        clear_all_errors
        add_errors(all_errors)
      end
    end
  end
end
