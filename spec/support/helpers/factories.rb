# frozen_string_literal: true

module SpecHelpers
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

  module Factories
    INTERACTOR_BASE_CLASS = ActiveInteractor::Interactor

    def build_interactor(class_name = 'TestInteractor', &block)
      build_class(class_name, INTERACTOR_BASE_CLASS, &block)
    end

    private

    def build_class(class_name, parent_class = nil, &block)
      Object.send(:remove_const, class_name.to_sym) if Object.const_defined?(class_name)
      klass = create_class(class_name, parent_class)
      klass.class_eval(&block) if block
      FactoryCollection.register(klass)
      klass
    end

    def create_class(class_name, parent_class = nil)
      return Object.const_set(class_name, Class.new) unless parent_class

      Object.const_set(class_name, Class.new(parent_class))
    end
  end
end
