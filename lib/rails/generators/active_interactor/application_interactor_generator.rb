# frozen_string_literal: true

module ActiveInteractor
  module Generators
    class ApplicationInteractorGenerator < ActiveInteractor::Generators::HiddenBase
      def create_application_interactor
        template 'application_interactor.erb', File.join('app', 'interactors', 'application_interactor.rb')
      end
    end
  end
end
