# frozen_string_literal: true

module ActiveInteractor
  module Rails
    # The ActiveInteractor rails configuration object
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @!attribute [rw] directory
    #  @return [String] the directory interactors are stored in
    # @!attribute [rw] generate_context_classes
    #  @return [Boolean] whether or not to generate a seperate
    #    context class for an interactor.
    class Config
      # @return [Hash{Symbol=>*}] the default configuration options
      DEFAULTS = {
        directory: 'interactors',
        generate_context_classes: true
      }.freeze

      attr_accessor :directory, :generate_context_classes

      # @param options [Hash] the options for the configuration
      # @option options [String] :directory (defaults to: 'interactors') the configuration directory property
      # @option options [Boolean] :generate_context_classes (defaults to: `true`) the configuration
      #   generate_context_class property.
      # @return [Config] a new instance of {Config}
      def initialize(options = {})
        DEFAULTS.dup.merge(options).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
