# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class ContextGenerator < NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor context'
      argument :interactors, type: :array, default: [], banner: 'name name'

      def create_context
        template 'context.erb', file_path
      end

      hook_for :test_framework, in: :'interactor:context'

      private

      def file_path
        File.join('app', interactor_dir, File.join(class_path), "#{file_name}_context.rb")
      end
    end
  end
end
