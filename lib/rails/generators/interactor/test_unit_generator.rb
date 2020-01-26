# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module Interactor
  module Generators
    class TestUnitGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor unit test'

      def create_spec
        template 'interactor_test_unit.erb', active_interactor_file(parent_dir: 'test', suffix: 'test')
      end
    end
  end
end
