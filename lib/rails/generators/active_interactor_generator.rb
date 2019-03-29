# frozen_string_literal: true

require_relative 'active_interactor'

class ActiveInteractorGenerator < ActiveInteractor::Generators::Base
  hide!
  after_bundle do
    generate 'active_interactor:install'
  end
end
