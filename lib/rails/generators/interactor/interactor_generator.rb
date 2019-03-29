# frozen_string_literal: true

class InteractorGenerator < ActiveInteractor::Genreators::NamedBase
  desc 'Generate an interactor'

  def create_interactor
    template 'interactor.erb', File.join('app', 'interactors', class_path, "#{file_name}.rb")
  end

  hook_for :test_framework, in: :interactor
end
