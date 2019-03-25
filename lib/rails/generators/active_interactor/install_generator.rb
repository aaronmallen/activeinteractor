# frozen_string_literal: true

require 'rails/generators/base'

module ActiveInteractor
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)
      desc 'Installs ActiveInteractor.'

      def install
        generate 'active_interactor:initializer'
        generate 'active_interactor:application_interactor'
      end
    end
  end
end
