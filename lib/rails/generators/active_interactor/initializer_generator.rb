# frozen_string_literal: true

require 'rails/generators/named_base'

module ActiveInteractor
  class InitializerGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __dir__)

    def create_initializer
      template 'initializer.rb', 'config/initializers/active_interactor.rb'
    end
  end
end
