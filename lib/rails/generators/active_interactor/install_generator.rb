# frozen_string_literal: true

require 'rails/generators/active_interactor/base'

module ActiveInteractor
  module Generators
    class InstallGenerator < Base
      desc 'Install ActiveInteractor'
      class_option :orm

      def create_initializer
        template 'active_interactor.erb', File.join('config', 'initializers', 'active_interactor.rb')
      end
    end
  end
end
