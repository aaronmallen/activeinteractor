# frozen_string_literal: true

module ActiveInteractor
  # The deprecation manager used to warn about methods being deprecated in the next major release.
  #
  # @since unreleased
  # @see https://api.rubyonrails.org/classes/ActiveSupport/Deprecation.html ActiveSupport::Deprecation
  #
  # @return [ActiveSupport::Deprecation] an instance of `ActiveSupport::Deprecation`
  NextMajorDeprecator = ActiveSupport::Deprecation.new('2.0', 'ActiveInteractor')

  # The logger instance to use for logging
  #
  # @since 0.1.0
  #
  # @return [Class] the {Config#logger #config#logger} instance
  def self.logger
    config.logger
  end
end
