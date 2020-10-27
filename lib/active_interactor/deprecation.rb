# frozen_string_literal: true

module ActiveInteractor
  # ActiveSupport::Deprecation instances used for deprecation logging.
  #
  # @see https://api.rubyonrails.org/classes/ActiveSupport/Deprecation.html ActiveSupport::Deprecation
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since unreleased
  module Deprecation
    class << self
      # Disable deprecation debuging
      def disable_debugging!
        each_deprecator { |deprecator| deprecator.debug = false }
      end

      # Disable deprecation logging
      def disable_logging!
        each_deprecator { |deprecator| deprecator.silenced = true }
      end

      # Enable deprecation debuging
      def enable_debugging!
        each_deprecator { |deprecator| deprecator.debug = true }
      end

      # Enable deprecation logging
      def enable_logging!
        each_deprecator { |deprecator| deprecator.silenced = false }
      end

      private

      def deprecator(deprecation_horizon)
        instance = ActiveSupport::Deprecation.new(deprecation_horizon, 'ActiveInteractor')
        instance.silenced = ActiveInteractor.config.silence_deprecation_warnings
        instance.debug = ActiveInteractor.config.deprecation_debugging
        instance
      end

      def deprecators
        constants.map { |name| const_get(name) }
                 .select { |constant| constant.is_a?(ActiveSupport::Deprecation) }
                 .compact
      end

      def each_deprecator
        deprecators.each do |deprecator|
          yield deprecator if block_given?
        end
      end
    end

    # ActiveInteractor version 2.0 deprecator
    #
    # @api private
    # @return [ActiveSupport::Deprecation] the 2.0 deprecator instance
    V2 = deprecator('2.0')
  end
end
