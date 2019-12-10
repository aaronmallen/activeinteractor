# frozen_string_literal: true

require 'rails/generators/named_base'

class InteractorGenerator < ::Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  desc 'Generate an interactor'

  def create_interactor
    template 'interactor.erb', Rails.root.join('app/interactors', File.join(class_path), "#{file_name}.rb")
  end

  def create_context
    generate :'interactor:context', class_name
  end

  hook_for :test_framework, in: :interactor
end
