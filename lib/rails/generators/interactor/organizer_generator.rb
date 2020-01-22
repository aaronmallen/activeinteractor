# frozen_string_literal: true

require 'rails/generators/active_interactor/base'
require 'rails/generators/interactor/generates_context'

module Interactor
  module Generators
    class OrganizerGenerator < ActiveInteractor::Generators::NamedBase
      include GeneratesContext
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'interactor interactor'

      class_option :context_attributes, type: :array, default: [], banner: 'attribute attribute',
                                        desc: 'Attributes for the context'

      def generate_application_organizer
        generate :'active_interactor:application_organizer'
      end

      def create_organizer
        template 'organizer.erb', active_interactor_file
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
    end
  end
end
