# frozen_string_literal: true

require 'active_support/concern'
require 'rails/generators/base'
require 'rails/generators/named_base'

Dir[File.expand_path('active_interactor/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }

module ActiveInteractor
  module Generators
    module BasicGenerator
      extend ActiveSupport::Concern

      included do
        source_root File.expand_path('../templates', __dir__)
      end
    end

    class Base < ::Rails::Generators::Base
      include BasicGenerator
    end

    class HiddenBase < ::Rails::Generators::Base
      include BasicGenerator
      hide!
    end

    class NamedBase < ::Rails::Generators::NamedBase
      include BasicGenerator
    end
  end
end
