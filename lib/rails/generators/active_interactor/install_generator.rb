# frozen_string_literal: true

require_relative '../active_interactor'

module ActiveInteractor
  module Generators
    class InstallGenerator < ActiveInteractor::Generators::Base
      hide!

      def create_initializer
        template 'initializer.rb', File.join('config', 'initializers', 'active_interactor.rb')
      end

      def create_application_interactor
        template 'application_interactor.erb', File.join('app', 'interactors', 'application_interactor.rb')
      end

      def create_interactor_concerns
        create_file 'app/interactors/concerns/.keep'
      end

      def autoload_interactors
        application do
          <<~CONFIG
             # autoload interactors
            config.autoload_paths += %w[app/interactors]

          CONFIG
        end
      end
    end
  end
end
