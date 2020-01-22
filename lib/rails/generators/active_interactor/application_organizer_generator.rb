# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module ActiveInteractor
  module Generators
    class ApplicationOrganizerGenerator < Base
      def create_application_organizer
        return if File.exist?(file_path)

        template 'application_organizer.rb', file_path
      end

      private

      def file_path
        "app/#{active_interactor_directory}/application_organizer.rb"
      end
    end
  end
end
