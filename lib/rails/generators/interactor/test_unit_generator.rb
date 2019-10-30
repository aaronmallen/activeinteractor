# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class TestUnitGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor unit test'

      def create_interactor_test
        file_path = Rails.root.join('test', app_dir_name, File.join(class_path), "#{file_name}_test.rb")
        template 'interactor_test_unit.erb', file_path
      end

      def create_context_test
        return unless ActiveInteractor.configuration.generate_context_class

        file_path = Rails.root.join('test', app_dir_name, 'context', File.join(class_path), "#{file_name}_test.rb")
        template 'context_test_unit.erb', file_path
      end
    end
  end
end
