# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Options object for interactor perform
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @!attribute [rw] skip_perform_callbacks
    #  @return [Boolean] whether or not to skip :perform callbacks
    # @!attribute [rw] skip_rollback
    #  @return [Boolean] whether or not to skip rollback when an interactor
    #    fails its context
    # @!attribute [rw] skip_rollback_callbacks
    #  @return [Boolean] whether or not to skip :rollback callbacks
    # @!attribute [rw] validate
    #  @return [Boolean] whether or not to run validations on an interactor
    # @!attribute [rw] validate_on_calling
    #  @return [Boolean] whether or not to run validation on :calling
    # @!attribute [rw] validate_on_called
    #  @return [Boolean] whether or not to run validation on :called
    class PerformOptions
      # Default options for interactor perform
      # @return [Hash{Symbol=>*}] the default options
      DEFAULTS = {
        skip_perform_callbacks: false,
        skip_rollback: false,
        skip_rollback_callbacks: false,
        validate: true,
        validate_on_calling: true,
        validate_on_called: true
      }.freeze

      attr_accessor :skip_perform_callbacks, :skip_rollback, :skip_rollback_callbacks,
                    :validate, :validate_on_calling, :validate_on_called

      # @param options [Hash] the attributes for the {PerformOptions}
      # @return [PerformOptions] a new instance of {PerformOptions}
      def initialize(options = {})
        DEFAULTS.dup.merge(options).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
