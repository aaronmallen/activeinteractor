# frozen_string_literal: true

module ActiveInteractor
  # The Configuration object for the ActiveInteractor gem
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  #
  # @!attribute [rw] logger
  #  @return [Logger] an instance of Logger
  class Configuration
    # The default configuration options for {Configuration}
    # @return [Hash{Symbol => *}]
    CONFIGURATION_DEFAULTS = {
      logger: Logger.new(STDOUT)
    }.freeze

    attr_accessor :logger

    # A new instance of {Configuration}
    # @param options [Hash{Symbol => *}] the options to initialize the
    #  configuration with.
    # @option options [Logger] :logger the logger ActiveInteractor should
    #  use for logging
    # @return [ActiveInteractor::Configuration] a new instance of {Configuration}
    def initialize(options = {})
      options = CONFIGURATION_DEFAULTS.merge(options.dup)
      @logger = options[:logger]
    end
  end
end
