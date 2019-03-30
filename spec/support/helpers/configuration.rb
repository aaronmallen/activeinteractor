# frozen_string_literal: true

module Spec
  module Helpers
    module Configuration
      def reset_config_to_default!
        ActiveInteractor.configure do |config|
          ActiveInteractor::Configuration::DEFAULTS.each do |option, value|
            config.send("#{option}=", value)
          end
        end
      end
    end
  end
end
