# frozen_string_literal: true

require 'rails/generators/base'

module ActiveInteractor
  module Generators
    class InitializerGenerator < ::Rails::Generators::Base
      hide!
      source_root File.expand_path('../templates', __dir__)

      def create_initializer
        template 'initializer.rb', 'config/initializers/active_interactor.rb'
      end
    end
  end
end
