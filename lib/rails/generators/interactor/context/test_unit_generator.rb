# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module Interactor
  module Context
    module Generators
      class TestUnitGenerator < ActiveInteractor::Generators::NamedBase
        desc 'Generate an interactor context unit test'

        def create_spec
          template 'context_test_unit.erb', active_interactor_file(parent_dir: 'test', suffix: 'context_test')
        end
      end
    end
  end
end
