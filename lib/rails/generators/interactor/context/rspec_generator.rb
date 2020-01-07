# frozen_string_literal: true

require_relative '../../active_interactor'

module Interactor
  module Context
    module Generators
      class RspecGenerator < ActiveInteractor::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)
        desc 'Generate an interactor spec'

        def create_spec
          template 'rspec.erb', file_path
        end

        private

        def file_path
          File.join('spec', interactor_directory, File.join(class_path), "#{file_name}_context_spec.rb")
        end
      end
    end
  end
end
