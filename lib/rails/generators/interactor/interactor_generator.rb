# frozen_string_literal: true

require 'rails/generators/active_interactor/base'
require 'rails/generators/interactor/generates_context'

class InteractorGenerator < ActiveInteractor::Generators::NamedBase
  include Interactor::Generators::GeneratesContext::WithArguments
  desc 'Generate an interactor'

  def generate_application_interactor
    generate :'active_interactor:application_interactor'
  end

  def create_interactor
    template 'interactor.erb', active_interactor_file
  end

  def create_context
    return if skip_context?

    generate :'interactor:context', class_name, *context_attributes
  end

  hook_for :test_framework, in: :interactor
end
