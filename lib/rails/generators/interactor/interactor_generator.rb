# frozen_string_literal: true

require_relative '../active_interactor'

class InteractorGenerator < ActiveInteractor::Generators::NamedBase
  desc 'Generate an interactor'

  def create_interactor
    template 'interactor.erb', Rails.root.join('app', app_dir_name, File.join(class_path), "#{file_name}.rb")
  end

  hook_for :test_framework, in: :interactor
end
