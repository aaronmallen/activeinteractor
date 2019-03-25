# frozen_string_literal: true

require 'active_interactor/rails/generators/active_interactor'

module ActiveInteractor
  module Generators
    class ApplicationInteractorGenerator < ActiveInteractor::Generator
      def self.file_name
        'application_interactor.rb'
      end
    end
  end
end
