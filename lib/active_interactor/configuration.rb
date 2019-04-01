# frozen_string_literal: true

module ActiveInteractor
  # The Configuration object for the ActiveInteractor gem
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.2
  #
  # @!attribute [rw] logger
  #  @return [Logger] an instance of Logger
  # @!attribute [rw] dir_name
  #  @return [String] The directory name interactors are generated in
  class Configuration
    # The default configuration options for {Configuration}
    # @return [Hash{Symbol => *}]
    DEFAULTS = {
      logger: Logger.new(STDOUT),
      dir_name: 'interactors'
    }.freeze

    attr_accessor :logger, :dir_name

    # A new instance of {Configuration}
    # @param options [Hash{Symbol => *}] the options to initialize the
    #  configuration with.
    # @option options [Logger] :logger the logger ActiveInteractor should
    #  use for logging
    # @option options [String] :dir_name he directory name interactors are generated in
    # @return [ActiveInteractor::Configuration] a new instance of {Configuration}
    def initialize(options = {})
      options = DEFAULTS.merge(options.dup || {}).slice(*DEFAULTS.keys)
      options.each_key do |attribute|
        instance_variable_set("@#{attribute}", options[attribute])
      end
    end
  end
end
