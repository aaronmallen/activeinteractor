# frozen_string_literal: true

require 'rails/generators/base'

module ActiveInteractor
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc 'Install ActiveInteractor'

      def create_initializer
        template 'initializer.erb', Rails.root.join('config', 'initializers', 'active_interactor.rb')
      end

      def create_application_interactor_and_context
        generate :'active_interactor:application_interactor'
      end

      def autoload_interactors
        application do
          <<-CONFIG
          # autoload interactors
          config.autoload_paths += %w[app/interactors]

          CONFIG
        end
      end
    end
  end
end
