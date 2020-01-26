# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module Interactor
  module Context
    module Generators
      class RspecGenerator < ActiveInteractor::Generators::NamedBase
        desc 'Generate an interactor context spec'

        def create_spec
          template 'context_spec.erb', active_interactor_file(parent_dir: 'spec', suffix: 'context_spec')
        end
      end
    end
  end
end
