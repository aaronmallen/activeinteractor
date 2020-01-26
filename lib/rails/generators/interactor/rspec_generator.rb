# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module Interactor
  module Generators
    class RspecGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor spec'

      def create_spec
        template 'interactor_spec.erb', active_interactor_file(parent_dir: 'spec', suffix: 'spec')
      end
    end
  end
end
