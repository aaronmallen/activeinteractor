# frozen_string_literal: true

module Interactor
  module Generators
    class OrganizerGenerator < ActiveInteractor::Genreators::NamedBase
      desc 'Generate an interactor organizer'
      argument :interactors, type: :array, default: [], banner: 'name name'

      def create_organizer
        template 'organizer.erb', File.join('app', 'interactors', class_path, "#{file_name}.rb")
      end

      hook_for :test_framework, in: :interactor
    end
  end
end
