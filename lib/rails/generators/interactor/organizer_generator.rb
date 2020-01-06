# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class OrganizerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'name name'

      def create_organizer
        template 'organizer.erb', Rails.root.join('app/interactors', File.join(class_path), "#{file_name}.rb")
      end

      def create_context
        generate :'interactor:context', class_name
      end

      hook_for :test_framework, in: :interactor
    end
  end
end
