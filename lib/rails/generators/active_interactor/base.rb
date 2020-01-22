# frozen_string_literal: true

require 'rails/generators'

require 'rails/generators/active_interactor/generator'

module ActiveInteractor
  module Generators
    class Base < ::Rails::Generators::Base
      extend Generator
      include Generator
    end

    class NamedBase < ::Rails::Generators::NamedBase
      extend Generator
      include Generator

      private

      def active_interactor_file(parent_dir: 'app', suffix: nil)
        File.join(parent_dir, active_interactor_directory, class_path, "#{file_name_with_suffix(suffix)}.rb")
      end

      def file_name_with_suffix(suffix)
        suffix ? "#{file_name}_#{suffix}" : file_name
      end
    end
  end
end
