# frozen_string_literal: true

require 'rails/generators/named_base'
require 'active_interactor'

module ActiveInteractor
  module Generators
    module Generator
      private

      def interactor_dir
        @interactor_dir ||= ActiveInteractor.config.rails.directory
      end
    end
    class Base < ::Rails::Generators::Base
      include Generator
    end

    class NamedBase < ::Rails::Generators::NamedBase
      include Generator
    end
  end
end

Dir[File.expand_path('active_interactor/*.rb', __dir__)].sort.each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].sort.each { |file| require file }
