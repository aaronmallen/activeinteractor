# frozen_string_literal: true

require 'logger'

module ActiveInteractor
  # The ActiveInteractor configuration object
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  # @!attribute [rw] logger
  #  @return [Logger] an instance of Logger
  class Config
    # @return [Hash{Symbol=>*}] the default configuration options
    DEFAULTS = {
      logger: Logger.new(STDOUT)
    }.freeze

    attr_accessor :logger

    # @param options [Hash] the options for the configuration
    # @option options [Logger] :logger the configuration logger instance
    # @return [Config] a new instance of {Config}
    def initialize(options = {})
      DEFAULTS.dup.merge(options).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # The rails configuration object
    # @return [Rails::Config|nil] an instance of {Rails::Config} if `Rails` is
    #  defined or `nil`.
    def rails
      @rails ||= begin
        return unless defined?(::Rails)

        require 'active_interactor/rails/config'
        Rails::Config.new
      end
    end
  end

  # The ActiveInteractor configuration
  # @since 0.0.1
  # @return [ActiveInteractor::Config] the configuration instance
  def self.config
    @config ||= Config.new
  end

  # Configures the ActiveInteractor gem
  # @since 0.0.1
  # @example Configure ActiveInteractor
  #  ActiveInteractor.configure do |config|
  #    config.logger = Rails.logger
  #  end
  # @yield [ActiveInteractor#config]
  def self.configure
    yield config
  end

  # The ActiveInteractor logger object
  # @since 0.0.1
  # @return [Logger] an instance of Logger
  def self.logger
    config.logger
  end
end
