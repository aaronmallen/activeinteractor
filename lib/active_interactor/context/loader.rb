# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Find or create {Base context} classes for a given {ActiveInteractor::Base interactor}
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen>
    # @since 1.0.0
    module Loader
      # ActiveInteractor base classes
      # @return [Array<Const>]
      BASE_CLASSES = [ActiveInteractor::Base, ActiveInteractor::Organizer::Base].freeze
      # The {ActiveInteractor::Context::Base} class
      # @return [Const]
      BASE_CONTEXT = ActiveInteractor::Context::Base

      # Create a {Base context} class for a given {ActiveInteractor::Base interactor}
      #
      # @param context_class_name [Symbol, String] the class name of the
      #   {Base context} class to create
      # @param interactor_class [Const] an {ActiveInteractor::Base interactor} class
      # @return [Const] a class that inherits from {Base}
      def self.create(context_class_name, interactor_class)
        interactor_class.const_set(context_class_name.to_s.classify, Class.new(BASE_CONTEXT))
      end

      # Find or create a {Base context} class for a given {ActiveInteractor::Base interactor}. If a class exists
      # following the pattern of `InteractorNameContext` or `InteractorName::Context` then that class will be returned
      # otherwise a new class will be created with the pattern `InteractorName::Context`.
      #
      # @param interactor_class [Const] an {ActiveInteractor::Base interactor} class
      # @return [Const] a class that inherits from {Base}
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
