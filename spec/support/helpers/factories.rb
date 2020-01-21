# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Spec
  module Helpers
    module FactoryCollection
      def self.factories
        @factories ||= []
      end
    end

    module Factories
      def build_class(class_name, parent_class = nil, &block)
        Object.send(:remove_const, class_name.to_sym) if Object.const_defined?(class_name)
        klass = create_class(class_name, parent_class)
        klass.class_eval(&block) if block
        FactoryCollection.factories << klass.name.to_sym
        klass
      end

      def build_context(class_name = 'TestContext', &block)
        build_class(class_name, ActiveInteractor::Context::Base, &block)
      end

      def build_interactor(class_name = 'TestInteractor', &block)
        build_class(class_name, ActiveInteractor::Base, &block)
      end

      def build_organizer(class_name = 'TestOrganizer', &block)
        build_class(class_name, ActiveInteractor::Organizer, &block)
      end

      def clean_factories!
        FactoryCollection.factories.each do |factory|
          Object.send(:remove_const, factory) if Object.const_defined?(factory)
        end
      end

      private

      def create_class(class_name, parent_class = nil)
        return Object.const_set(class_name, Class.new) unless parent_class

        Object.const_set(class_name, Class.new(parent_class))
      end
    end
  end
end
