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
    DEFAULTS = {
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
      options = DEFAULTS.merge(options.dup || {}).slice(*DEFAULTS.keys)
      options.each_key do |attribute|
        instance_variable_set("@#{attribute}", options[attribute])
      end
    end
  end
end
