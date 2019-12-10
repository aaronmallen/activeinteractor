# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class ContextGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor context'
      argument :interactors, type: :array, default: [], banner: 'name name'

      def create_context
        template 'context.erb', Rails.root.join('app/interactors', File.join(class_path), "#{file_name}_context.rb")
      end

      hook_for :test_framework, in: :'interactor:context'
    end
  end
end
