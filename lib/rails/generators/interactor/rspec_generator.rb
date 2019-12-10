# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class RspecGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Generate an interactor spec'

      def create_spec
        template 'rspec.erb', Rails.root.join('spec/interactors', File.join(class_path), "#{file_name}_spec.rb")
      end
    end
  end
end
