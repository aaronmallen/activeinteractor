# frozen_string_literal: true

module ActiveInteractor
  module Spec
    class FactoryCollection
      class << self
        def register(factory)
          factories << factory.name.to_sym
        end

        def clean!
          factories.each do |factory_name|
            Object.send(:remove_const, factory_name) if Object.const_defined?(factory_name)
          end

          @factories = []
        end

        private

        def factories
          @factories ||= []
        end
      end
    end
  end
end
