# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class OrganizerGenerator < ActiveInteractor::Generators::NamedBase
      include ActiveInteractor::Generators::GeneratesContext
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'name name'

      def create_organizer
        template 'organizer.erb', file_path
      end

      def create_context
        return if skip_context?

        generate :'interactor:context', class_name, *context_attributes
      end

      hook_for :test_framework, in: :interactor

      private

      def file_path
        File.join('app', interactor_directory, File.join(class_path), "#{file_name}.rb")
      end
    end
  end
end
