# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class TestUnitGenerator < ActiveInteractor::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor unit test'

      def create_test
        template 'test_unit.erb', file_path
      end

      private

      def file_path
        File.join('test', interactor_directory, File.join(class_path), "#{file_name}_test.rb")
      end
    end
  end
end
