# frozen_string_literal: true

module ActiveInteractor
  # The ActiveInteractor configuration object
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  #
  # @!attribute [rw] deprecation_debugging
  #  Whether or not to enable debugging for deprecation messages. Deprecation debugging is `false` by default.
  #
  #  @since unreleased
  #  @see https://api.rubyonrails.org/classes/ActiveSupport/Deprecation.html ActiveSupport::Deprecation
  #
  #  @return [Boolean] `true` if enabled or `false` if disabled
  #
  # @!attribute [rw] logger
  #  The logger instance to use for logging.
  #
  #  @since 1.0.0
  #
  #  @return [Class] an instance of Logger.
  #
  # @!attribute [rw] silence_deprecation_warnings
  #  Whether or not to silence deprecation messages. Deprecation silencing is `false` by default.
  #
  #  @since unreleased
  #  @see https://api.rubyonrails.org/classes/ActiveSupport/Deprecation.html ActiveSupport::Deprecation
  #
  #  @return [Boolean] `true` if silenced or `false` if not silenced
  #
  # @!method initialize(options = {})
  #  Initialize a new instance of {Config}
  #
  #  @since 1.0.0
  #
  #  @param options [Hash{Symbol=>*}] the attributes to assign to {Config}
  #  @option options [Class] :logger (Logger.new(STDOUT)) the {Config#logger} attribute
  #  @return [Config] a new instance of {Config}
  class Config
    include ActiveInteractor::Configurable
    defaults deprecation_debugging: false, logger: Logger.new($stdout), silence_deprecation_warnings: false
  end

  # The ActiveInteractor configuration
  #
  # @since 0.1.0
  #
  # @return [Config] a {Config} instance
  def self.config
    @config ||= ActiveInteractor::Config.new
  end

  # Configure the ActiveInteractor gem
  #
  # @since 0.1.0
  #
  # @example Configure ActiveInteractor
  #   require 'active_interactor'
  #   ActiveInteractor.configure do |config|
  #     config.logger = ::Rails.logger
  #   end
  # @yield [#config]
  def self.configure
    yield config
  end

  # The logger instance to use for logging
  #
  # @since 0.1.0
  #
  # @return [Class] the {Config#logger #config#logger} instance
  def self.logger
    config.logger
  end
end
