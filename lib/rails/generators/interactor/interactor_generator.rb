# frozen_string_literal: true

require_relative '../active_interactor'

class InteractorGenerator < ActiveInteractor::Generators::NamedBase
  desc 'Generate an interactor'
  argument :context_attributes, type: :array, default: [], banner: '[field field]'

  def create_interactor
    template 'interactor.erb', Rails.root.join('app', app_dir_name, File.join(class_path), "#{file_name}.rb")
  end

  def create_context
    return unless ActiveInteractor.configuration.generate_context_class

    template 'context.erb', Rails.root.join('app', app_dir_name, 'context', File.join(class_path), "#{file_name}.rb")
  end

  hook_for :test_framework, in: :interactor
end
