# frozen_string_literal: true

require_relative '../active_interactor'

module ActiveInteractor
  module Generators
    class InstallGenerator < Base
      desc 'Install ActiveInteractor'
      argument :directory, type: :string, default: 'interactors', banner: 'directory'

      def create_initializer
        template 'initializer.erb', Rails.root.join('config', 'initializers', 'active_interactor.rb')
      end

      def create_application_interactor
        template 'application_interactor.erb', Rails.root.join('app', app_dir_name, 'application_interactor.rb')
      end

      def create_interactor_concerns
        create_file Rails.root.join('app', app_dir_name, 'concerns', '.keep')
      end

      def autoload_interactors
        application do
          <<~CONFIG
             # autoload interactors
            config.autoload_paths += %w[app/#{app_dir_name}]

          CONFIG
        end
      end
    end
  end
end
