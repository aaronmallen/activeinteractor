# frozen_string_literal: true

module Interactor
  module Generators
    class TestUnitGenerator < ActiveInteractor::Genreators::NamedBase
      desc 'Generate an interactor unit test'

      def create_test
        template 'test_unit.erb', File.join('test', 'interactors', class_path, "#{file_name}_test.rb")
      end
    end
  end
end
