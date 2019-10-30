# frozen_string_literal: true

module ActiveInteractor
  # The Configuration object for the ActiveInteractor gem
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.3
  #
  # @!attribute [rw] logger
  #  @return [Logger] an instance of Logger
  # @!attribute [rw] dir_name
  #  @return [String] The directory name interactors are generated in
  # @!attribute [rw] generate_context_class
  #  @return [Boolean] Whether or not to automatically generate seperate
  #    context classes when an new interactor is created
  class Configuration
    # The default configuration options for {Configuration}
    # @return [Hash{Symbol => *}]
    DEFAULTS = {
      logger: Logger.new(STDOUT),
      dir_name: 'interactors',
      generate_context_class: true
    }.freeze

    attr_accessor :logger, :dir_name, :generate_context_class

    # A new instance of {Configuration}
    # @param options [Hash{Symbol => *}] the options to initialize the
    #  configuration with.
    # @option options [Logger] :logger defaults to `Logger.new(STDOUT)`
    # @option options [String] :dir_name defaults to 'interactors'
    # @option options [String] :generate_context_class defaults to `true`
    # @return [ActiveInteractor::Configuration] a new instance of {Configuration}
    def initialize(options = {})
      options = DEFAULTS.merge(options.dup || {}).slice(*DEFAULTS.keys)
      options.each_key do |attribute|
        instance_variable_set("@#{attribute}", options[attribute])
      end
    end
  end
end
