# frozen_string_literal: true

module ActiveInteractor
  # The logger instance to use for logging
  #
  # @since 0.1.0
  #
  # @return [Class] the {Config#logger #config#logger} instance
  def self.logger
    config.logger
  end
end
