# frozen_string_literal: true

require 'rails/generators/base'
require 'rails/generators/named_base'

require_relative 'active_interactor_generator'
require 'active_interactor'

module ActiveInteractor
  module Generators
    module Generator
      extend ActiveSupport::Concern

      class_methods do
        def self.base_root
          __dir__
        end

        def source_root
          File.expand_path('templates', __dir__)
        end
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

class ActiveInteractorGenerator < ActiveInteractor::Generators::Base
  hide!
  after_bundle do
    generate 'active_interactor:install'
  end
end

Dir[File.expand_path('active_interactor/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }
