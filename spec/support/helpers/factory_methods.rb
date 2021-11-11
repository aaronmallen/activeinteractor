# frozen_string_literal: true

require_relative '../factory_collection'

module ActiveInteractor
  module Spec
    module Helpers
      module FactoryMethods
        INTERACTOR_BASE_CLASS = ActiveInteractor::Interactor

        def build_interactor(class_name = 'TestInteractor', &block)
          build_class(class_name, INTERACTOR_BASE_CLASS, &block)
        end

        private

        def build_class(class_name, parent_class = nil, &block)
          Object.send(:remove_const, class_name.to_sym) if Object.const_defined?(class_name)
          klass = create_class(class_name, parent_class)
          klass.class_eval(&block) if block
          ActiveInteractor::Spec::FactoryCollection.register(klass)
          klass
        end

        def create_class(class_name, parent_class = nil)
          return Object.const_set(class_name, Class.new) unless parent_class

          Object.const_set(class_name, Class.new(parent_class))
        end
      end
    end
  end
end
