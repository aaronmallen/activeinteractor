# frozen_string_literal: true

require 'rails/generators/named_base'

module ActiveInteractor
  class InstallGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __dir__)
    desc 'Installs ActiveInteractor.'

    def install
      generate 'active_interactor:initializer'
      generate 'active_interactor:application_interactor'
    end
  end
end
