# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Context
    module Generators
      class TestUnitGenerator < ::Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)
        desc 'Generate an interactor unit test'

        def create_test
          file_path = Rails.root.join('test/interactors', File.join(class_path), "#{file_name}_context_test.rb")
          template 'test_unit.erb', file_path
        end
      end
    end
  end
end
