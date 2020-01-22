# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module ActiveInteractor
  module Generators
    class ApplicationContextGenerator < Base
      def create_application_organizer
        return if File.exist?(file_path)

        template 'application_context.rb', file_path
      end

      private

      def file_path
        "app/#{active_interactor_directory}/application_context.rb"
      end
    end
  end
end
