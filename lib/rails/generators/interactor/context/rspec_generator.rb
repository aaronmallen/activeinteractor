# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  module Context
    module Generators
      class RspecGenerator < ::Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)
        desc 'Generate an interactor spec'

        def create_spec
          file_path = Rails.root.join('spec/interactors', File.join(class_path), "#{file_name}_context_spec.rb")
          template 'rspec.erb', file_path
        end
      end
    end
  end
end
