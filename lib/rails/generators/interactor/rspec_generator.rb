# frozen_string_literal: true

require_relative '../active_interactor'

module Interactor
  module Generators
    class RspecGenerator < ActiveInteractor::Generators::NamedBase
      desc 'Generate an interactor spec'

      def create_spec
        template 'rspec.erb', Rails.root.join('spec', interactor_app_dir, class_path, "#{file_name}_spec.rb")
      end
    end
  end
end
