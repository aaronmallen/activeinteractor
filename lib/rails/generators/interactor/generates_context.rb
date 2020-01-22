# frozen_string_literal: true

module Interactor
  module Generators
    module GeneratesContext
      module WithArguments
        def self.included(base)
          base.class_eval do
            include GeneratesContext
            argument :context_attributes, type: :array, default: [], banner: 'attribute attribute'
          end
        end
      end

      def self.included(base)
        base.class_eval do
          class_option :skip_context, type: :boolean, desc: 'Whether or not to generate a context class'
        end
      end

      private

      def skip_context?
        options[:skip_context] == true || active_interactor_options.fetch(:generate_context, true) == false
      end
    end
  end
end
