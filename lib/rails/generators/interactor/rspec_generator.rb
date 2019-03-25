# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Generators
    class RspecGenerator < ::Rails::Generators::NamedBase
      desc 'Generate an interactor spec'
      source_root File.expand_path('../templates', __dir__)

      def create_spec
        template 'rspec.erb', File.join('spec', 'interactors', class_path, "#{file_name}_spec.rb")
      end
    end
  end
end
