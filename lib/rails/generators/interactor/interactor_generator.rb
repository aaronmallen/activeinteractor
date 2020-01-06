# frozen_string_literal: true

require_relative '../active_interactor'

class InteractorGenerator < NamedBase
  source_root File.expand_path('templates', __dir__)
  desc 'Generate an interactor'

  def create_interactor
    template 'interactor.erb', file_path
  end

  def create_context
    generate :'interactor:context', class_name
  end

  hook_for :test_framework, in: :interactor

  private

  def file_path
    File.join('app', interactor_dir, File.join(class_path), "#{file_name}.rb")
  end
end
