# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class TestUnitGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor unit test'

      def create_test
        template 'test_unit.erb', Rails.root.join('test/interactors', File.join(class_path), "#{file_name}_test.rb")
      end
    end
  end
end
