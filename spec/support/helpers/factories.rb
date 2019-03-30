# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Spec
  module Helpers
    module Factories
      def build_class(class_name, parent_class = nil, &block)
        Object.send(:remove_const, class_name.to_sym) if Object.const_defined?(class_name)
        klass = Object.const_set(class_name, Class.new(parent_class))
        klass.class_eval(&block) if block
        klass
      end

      def build_context(class_name = 'TestContext', &block)
        build_class(class_name, ActiveInteractor::Context::Base, &block)
      end

      def build_interactor(class_name = 'TestInteractor', &block)
        build_class(class_name, ActiveInteractor::Base, &block)
      end

      def build_interactor_context(class_name = 'TestInteractor', &block)
        interactor = build_interactor(class_name, &block)
        interactor.context_class
      end
    end
  end
end
