# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class RspecGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor spec'

      def create_interactor_spec
        file_path = Rails.root.join('spec', app_dir_name, File.join(class_path), "#{file_name}_spec.rb")
        template 'interactor_rspec.erb', file_path
      end

      def create_context_spec
        return unless ActiveInteractor.configuration.generate_context_class

        file_path = Rails.root.join('spec', app_dir_name, 'context', File.join(class_path), "#{file_name}_spec.rb")
        template 'context_rspec.erb', file_path
      end
    end
  end
end
