# frozen_string_literal: true

require 'rails/generators/base'

module ActiveInteractor
  module Generators
    class ApplicationInteractorGenerator < ::Rails::Generators::Base
      hide!
      source_root File.expand_path('../templates', __dir__)

      def create_application_interactor
        template 'application_interactor.erb', File.join('app', 'interactors', 'application_interactor.rb')
      end
    end
  end
end
