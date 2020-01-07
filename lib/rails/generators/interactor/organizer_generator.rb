# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class OrganizerGenerator < ActiveInteractor::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'interactor interactor'

      class_option :context_attributes, type: :array, default: [], banner: 'attribute attribute'
      class_option :skip_context, type: :boolean

      def create_organizer
        template 'organizer.erb', file_path
      end

      def create_context
        return if skip_context?

        generate :'interactor:context', class_name, *context_attributes
      end

      hook_for :test_framework, in: :interactor

      private

      def context_attributes
        options[:context_attributes]
      end

      def file_path
        File.join('app', interactor_directory, File.join(class_path), "#{file_name}.rb")
      end

      def skip_context?
        options[:skip_context] == true || ActiveInteractor.config.rails.generate_context_classes == false
      end
    end
  end
end
