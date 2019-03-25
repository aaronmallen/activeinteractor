# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class TestUnitGenerator < ::Rails::Generators::NamedBase
      desc 'Generate an interactor unit test'
      source_root File.expand_path('../templates', __dir__)

      def create_test
        template 'test_unit.erb', File.join('test', 'interactors', class_path, "#{file_name}_test.rb")
      end
    end
  end
end
