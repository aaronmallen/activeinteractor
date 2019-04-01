# frozen_string_literal: true

require 'rails/generators/base'
require 'rails/generators/named_base'

require 'active_interactor'

module ActiveInteractor
  module Generators
    module Generator
      extend ActiveSupport::Concern

      class_methods do
        def base_root
          __dir__
        end

        def source_root
          File.expand_path('templates', __dir__)
        end
      end

      def app_dir_name
        ActiveInteractor.configuration.dir_name
      end
    end

    class Base < ::Rails::Generators::Base
      include Generator
    end

    class NamedBase < ::Rails::Generators::NamedBase
      include Generator
    end
  end
end

Dir[File.expand_path('active_interactor/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }
