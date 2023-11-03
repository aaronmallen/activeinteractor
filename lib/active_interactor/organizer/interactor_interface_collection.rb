# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # A collection of {InteractorInterface}
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    #
    # @!attribute [r] collection
    #  An array of {InteractorInterface}
    #
    #  @return [Array<InteractorInterface>] the {InteractorInterface} collection
    class InteractorInterfaceCollection
      attr_reader :collection

      # @!method map(&block)
      #  Invokes the given block once for each element of {#collection}.
      #  @return [Array] a new array containing the values returned by the block.
      delegate :map, to: :collection

      # Initialize a new instance of {InteractorInterfaceCollection}
      # @return [InteractorInterfaceCollection] a new instance of {InteractorInterfaceCollection}
      def initialize
        @collection = []
      end

      # Add an {InteractorInterface} to the {#collection}
      #
      # @param interactor_class [Const, Symbol, String] an {ActiveInteractor::Base interactor} class
      # @param filters [Hash{Symbol=> Proc, Symbol}] conditional options for the {ActiveInteractor::Base interactor}
      #  class
      # @option filters [Proc, Symbol] :if only call the {ActiveInteractor::Base interactor}
      #  {Interactor::Perform::ClassMethods#perform .perform} if `Proc` or `method` returns `true`
      # @option filters [Proc, Symbol] :unless only call the {ActiveInteractor::Base interactor}
      #  {Interactor::Perform::ClassMethods#perform .perform} if `Proc` or `method` returns `false` or `nil`
      # @return [self] the {InteractorInterfaceCollection} instance
      def add(interactor_class, filters = {})
        interface = ActiveInteractor::Organizer::InteractorInterface.new(interactor_class, filters)
        collection << interface if interface.interactor_class
        self
      end

      # Add multiple {InteractorInterface} to the {#collection}
      #
      # @param interactor_classes [Array<Const, Symbol, String>] the {ActiveInteractor::Base interactor} classes
      # @return [self] the {InteractorInterfaceCollection} instance
      def concat(interactor_classes)
        interactor_classes.flatten.each { |interactor_class| add(interactor_class) }
        self
      end

      # Calls the given block once for each element in {#collection}, passing that element as a parameter.
      # @return [self] the {InteractorInterfaceCollection} instance
      def each(&block)
        collection.each(&block) if block
        self
      end

      # Executes after_perform callbacks that have been deferred on each organized interactor
      def execute_deferred_after_perform_callbacks(context)
        each do |interface|
          if interface.interactor_class <= ActiveInteractor::Organizer::Base
            context.merge!(interface.interactor_class.organized.execute_deferred_after_perform_callbacks(context))
          else
            context.merge!(interface.execute_deferred_after_perform_callbacks(context))
          end
        end
      end
    end
  end
end
