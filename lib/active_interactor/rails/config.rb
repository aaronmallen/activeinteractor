# frozen_string_literal: true

module ActiveInteractor
  module Rails
    # The ActiveInteractor rails configuration object
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @!attribute [rw] directory
    #  @return [String] the directory interactors are stored in
    class Config
      # @return [Hash{Symbol=>*}] the default configuration options
      DEFAULTS = {
        directory: 'interactors'
      }.freeze

      attr_accessor :directory

      # @param options [Hash] the options for the configuration
      # @option options [String] :directory the configuration directory property
      # @return [Config] a new instance of {Config}
      def initialize(options = {})
        DEFAULTS.dup.merge(options).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
