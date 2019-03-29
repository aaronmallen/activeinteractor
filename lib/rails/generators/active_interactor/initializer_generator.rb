# frozen_string_literal: true

module ActiveInteractor
  module Generators
    class InitializerGenerator < ActiveInteractor::Generators::HiddenBase
      def create_initializer
        template 'initializer.rb', 'config/initializers/active_interactor.rb'
      end
    end
  end
end
