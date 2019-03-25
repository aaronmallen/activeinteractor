# frozen_string_literal: true

require 'rails/generators/named_base'

module Interactor
  class Generator < ::Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def generate
      template "#{self.class.generator_name}.erb", File.join('app', 'interactors', class_path, "#{file_name}.rb")
    end

    hook_for :test_framework
  end
end
