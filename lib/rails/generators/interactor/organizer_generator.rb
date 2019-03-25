# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class OrganizerGenerator < ::Rails::Generators::NamedBase
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'name name'
      source_root File.expand_path('../templates', __dir__)

      def create_organizer
        template 'organizer.erb', File.join('app', 'interactors', class_path, "#{file_name}.rb")
      end

      hook_for :test_framework, in: :interactor
    end
  end
end
