# frozen_string_literal: true

module ActiveInteractor
  class Configuration
    CONFIGURATION_DEFAULTS = {
      logger: Logger.new(STDOUT)
    }.freeze

    attr_accessor :logger

    def initialize(options = {})
      options = CONFIGURATION_DEFAULTS.merge(options.dup)
      @logger = options[:logger]
    end
  end
end
