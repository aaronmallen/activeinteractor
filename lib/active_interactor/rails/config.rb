# frozen_string_literal: true

require 'active_interactor/configurable'

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
      include ActiveInteractor::Configurable
      defaults directory: 'interactors', generate_context_classes: true

      # @!method initialize(options = {})
      # @param options [Hash] the options for the configuration
      # @option options [String] :directory (defaults to: 'interactors') the configuration directory property
      # @option options [Boolean] :generate_context_classes (defaults to: `true`) the configuration
      #   generate_context_class property.
      # @return [Config] a new instance of {Config}
    end

    # The {ActiveInteractor::Rails} configuration
    # @since 1.0.0
    # @return [ActiveInteractor::Config] the configuration instance
    def self.config
      @config ||= Config.new
    end

    # Configures {ActiveInteractor::Rails}
    # @since 1.0.0
    # @example Configure ActiveInteractor
    #  ActiveInteractor.configure do |config|
    #    config.logger = Rails.logger
    #  end
    # @yield [ActiveInteractor::Rails#config]
    def self.configure
      yield config
    end
  end
end
