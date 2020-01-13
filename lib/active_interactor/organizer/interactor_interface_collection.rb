# frozen_string_literal: true

require 'active_interactor/organizer/interactor_interface'

module ActiveInteractor
  class Organizer < ActiveInteractor::Base
    # @api private
    # A collection of ordered interactors for an {Organizer}
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @!attribute [r] collection
    #  @return [Array<Hash{Symbol=>*}] the organized interactors and filters
    class InteractorInterfaceCollection
      attr_reader :collection

      # @!method each(&block)
      # Calls the given block once for each element of {#collection}, passing that
      #  element as a parameter
      # @yield [.collection] the {#collection}
      # @return [Array<InteractorInterface>] the {#collection}

      # @!method map(&block)
      # Invokes the given block once fore each element of {#collection}.
      # @yield [.collection] the {#collection}
      # @return [Array] a new array containing the values returned by the block.
      delegate :each, :map, to: :collection

      # @return [InteractorInterfaceCollection] a new instance of {InteractorInterfaceCollection}
      def initialize
        @collection = []
      end

      # Add an {InteractorInterface} to the {#collection}
      # @param interactor [Class|Symbol|String] an interactor class name
      # @param filters [Hash{Symbol=>*}] conditions and {Interactor::PerformOptions} for the interactor
      # @option filters [Symbol|Proc] :if only invoke the interactor's perform method
      #   if method or block returns `true`
      # @option filters [Symbol|Proc] :unless only invoke the interactor's perform method
      #   if method or block returns `false`
      # @see Interactor::PerformOptions
      # @return [InteractorInterface] the {InteractorInterface} instance
      def add(interactor, filters = {})
        interface = InteractorInterface.new(interactor, filters)
        collection << interface if interface.interactor_class
        self
      end

      # Concat multiple {InteractorInterface} to the {#collection}
      # @param interactors [Array<Class>] the interactor classes to add
      #  to the collection
      # @return [InteractorInterface] the {InteractorInterface} instance
      def concat(interactors)
        interactors.flatten.each { |interactor| add(interactor) }
        self
      end
    end
  end
end
