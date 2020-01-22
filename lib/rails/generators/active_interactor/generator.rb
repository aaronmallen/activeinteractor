# frozen_string_literal: true

module ActiveInteractor
  module Generators
    module Generator
      def source_root
        File.expand_path('../templates', __dir__)
      end

      private

      def active_interactor_directory
        active_interactor_options.fetch(:dir, 'interactors')
      end

      def active_interactor_options
        ::Rails.application.config.generators.options.fetch(:active_interactor, {})
      end
    end
  end
end
