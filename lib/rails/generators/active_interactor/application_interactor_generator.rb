# frozen_string_literal: true

require 'rails/generators/base'

module ActiveInteractor
  module Generators
    class ApplicationInteractorGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_application_interactor
        template 'application_interactor.rb', Rails.root.join('app', 'interactors', 'application_interactor.rb')
      end

      def create_application_organizer
        template 'application_organizer.rb', Rails.root.join('app', 'interactors', 'application_organizer.rb')
      end

      def create_application_context
        template 'application_context.rb', Rails.root.join('app', 'interactors', 'application_context.rb')
      end
    end
  end
end
