# frozen_string_literal: true

module ActiveInteractor
  module Generators
    class InstallGenerator < ActiveInteractor::Generators::Base
      desc 'Installs ActiveInteractor.'

      def install
        generate 'active_interactor:initializer'
        generate 'active_interactor:application_interactor'
      end
    end
  end
end
