# frozen_string_literal: true

require_relative '../active_interactor'

module ActiveInteractor
  module Generators
    class ApplicationInteractorGenerator < Base
      source_root File.expand_path('templates', __dir__)

      def create_application_interactor
        template 'application_interactor.rb', File.join(target_path, 'application_interactor.rb')
      end

      def create_application_organizer
        template 'application_organizer.rb', File.join(target_path, 'application_organizer.rb')
      end

      def create_application_context
        return if ActiveInteractor.config.rails.generate_context_classes == false

        template 'application_context.rb', File.join(target_path, 'application_context.rb')
      end

      private

      def target_path
        "app/#{interactor_dir}"
      end
    end
  end
end
