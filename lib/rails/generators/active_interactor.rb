# frozen_string_literal: true

require 'rails/generators/named_base'
require 'active_interactor'

module ActiveInteractor
  module Generators
    module Generator
      private

      def interactor_directory
        @interactor_directory ||= ActiveInteractor::Rails.config.directory
      end
    end

    module GeneratesContext
      def self.included(base)
        base.class_eval do
          argument :context_attributes, type: :array, default: [], banner: 'attribute attribute'
          class_option :skip_context, type: :boolean, desc: 'Whether or not to generate a context class'
        end
      end

      private

      def skip_context?
        options[:skip_context] == true || ActiveInteractor::Rails.config.generate_context_classes == false
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
