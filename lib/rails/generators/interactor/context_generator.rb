# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module Interactor
  module Generators
    class ContextGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor context'
      argument :context_attributes, type: :array, default: [], banner: 'attribute attribute'

      def generate_application_context
        generate :'active_interactor:application_context'
      end

      def create_context
        template 'context.erb', active_interactor_file(suffix: 'context')
      end

      hook_for :test_framework, in: :'interactor:context'
    end
  end
end
