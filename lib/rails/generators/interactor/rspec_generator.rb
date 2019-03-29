# frozen_string_literal: true

module Interactor
  module Generators
    class RspecGenerator < ActiveInteractor::Genreators::NamedBase
      desc 'Generate an interactor spec'

      def create_spec
        template 'rspec.erb', File.join('spec', 'interactors', class_path, "#{file_name}_spec.rb")
      end
    end
  end
end
