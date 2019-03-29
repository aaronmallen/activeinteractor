# frozen_string_literal: true

require_relative 'active_interactor'

class ActiveInteractorGenerator < ActiveInteractor::Generators::Base
  hide!

  def install_active_interactor
    after_bundle do
      generate 'active_interactor:install'
    end
  end
end
