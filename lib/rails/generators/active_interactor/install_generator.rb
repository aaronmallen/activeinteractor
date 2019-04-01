# frozen_string_literal: true

require_relative '../active_interactor'

module ActiveInteractor
  module Generators
    class InstallGenerator < Base
      def create_initializer
        template 'initializer.rb', Rails.root.join('config', 'initializers', 'active_interactor.rb')
      end

      def create_application_interactor
        template 'application_interactor.erb', Rails.root.join('app', interactor_app_dir, 'application_interactor.rb')
      end

      def create_interactor_concerns
        create_file Rails.root.join('app', interactor_app_dir, 'concerns', '.keep')
      end

      def autoload_interactors
        application do
          <<~CONFIG
             # autoload interactors
            config.autoload_paths += %w[app/#{interactor_app_dir}]

          CONFIG
        end
      end
    end
  end
end
