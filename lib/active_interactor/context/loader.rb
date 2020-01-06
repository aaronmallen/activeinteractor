# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module ActiveInteractor
  module Context
    # @api private
    # Load, find or create {Context::Base} classes for a given interactor.
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Loader
      # @return [Array<Class>] ActiveInteractor base classes
      BASE_CLASSES = [ActiveInteractor::Base, ActiveInteractor::Organizer].freeze
      # @return [Class] the base context class
      BASE_CONTEXT = ActiveInteractor::Context::Base

      # Create a new context class on an interactor
      # @param context_class_name [String] the name of the class to create
      # @param interactor_class [Class] the interactor class to create the context for
      # @return [Class] the created context class
      def self.create(context_class_name, interactor_class)
        interactor_class.const_set(context_class_name.to_s.classify, Class.new(BASE_CONTEXT))
      end

      # Find or create a new context class for an interactor
      # @note the loader will attempt to find an existing context given the naming conventions:
      #   `MyInteractor::Context` or `MyInteractorContext`
      # @param interactor_class [Class] the interactor class to find or create the context for
      def self.find_or_create(interactor_class)
        return BASE_CONTEXT if BASE_CLASSES.include?(interactor_class)

        klass = possible_classes(interactor_class).first
        klass || create('Context', interactor_class)
      end

      def self.possible_classes(interactor_class)
        ["#{interactor_class.name}::Context", "#{interactor_class.name}Context"]
          .map(&:safe_constantize)
          .compact
          .reject { |klass| klass&.name&.include?('ActiveInteractor') }
      end
      private_class_method :possible_classes
    end
  end
end
