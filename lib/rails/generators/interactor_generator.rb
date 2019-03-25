# frozen_string_literal: true

require 'rails/generators/named_base'

class InteractorGenerator < ::Rails::Generators::NamedBase
  desc 'Generate an interactor'
  source_root File.expand_path('templates', __dir__)

  def create_interactor
    template 'interactor.erb', File.join('app', 'interactors', class_path, "#{file_name}.rb")
  end

  hook_for :test_framework, in: :interactor
end
