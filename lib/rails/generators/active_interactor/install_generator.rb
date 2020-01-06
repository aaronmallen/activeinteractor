# frozen_string_literal: true

require_relative '../active_interactor'

module ActiveInteractor
  module Generators
    class InstallGenerator < Base
      source_root File.expand_path('templates', __dir__)
      desc 'Install ActiveInteractor'
      argument :directory, type: :string, default: 'interactors', banner: 'directory'

      def create_initializer
        template 'initializer.erb', File.join('config', 'initializers', 'active_interactor.rb')
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
