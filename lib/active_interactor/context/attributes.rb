# frozen_string_literal: true

module ActiveInteractor
  module Context
    # Context attribute methods included by all {Context::Base}
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.4
    module Attributes
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      # Context attribute class methods extended by all {Context::Base}
      module ClassMethods
        # Set or get attributes defined on the context class
        # @example Set attributes on a context class
        #   class MyInteractor::Context < ActiveInteractor::Context::Base
        #     attributes :first_name, :last_name
        #   end
        # @example Get attributes defined on a context class
        #  MyInteractor::Context.attributes
        #  #=> [:first_name, :last_name]
        # @return [Array<Symbol>] the defined attributes
        def attributes(*attributes)
          return __attributes if attributes.empty?

          @__attributes = __attributes.concat(attributes).compact.uniq.sort
        end

        private

        def __attributes
          @__attributes ||= []
        end
      end

      # @api private
      # @param context [Hash|Context::Base] attributes to assign to the context
      # @return [Context::Base] a new instance of {Context::Base}
      def initialize(context = {})
        copy_flags!(context)
        super
      end

      # Attributes defined on the instance
      # @example Get attributes defined on an instance
      #   class MyInteractor::Context < ActiveInteractor::Context::Base
      #     attributes :first_name, :last_name
      #   end
      #
      #   class MyInteractor < ActiveInteractor::Base
      #     def perform; end
      #   end
      #
      #   result = MyInteractor.perform(first_name: 'Aaron', last_name: 'Allen', occupation: 'Software Nerd')
      #   #=> <#MyInteractor::Context first_name='Aaron' last_name='Allen' occupation='Software Nerd'>
      #
      #   result.attributes
      #   #=> { first_name: 'Aaron', last_name: 'Allen' }
      # @return [Hash{Symbol=>*}] the defined attributes and values
      def attributes
        self.class.attributes.each_with_object({}) do |attribute, hash|
          hash[attribute] = self[attribute] if self[attribute]
        end
      end

      private

      def copy_flags!(context)
        %w[_called _failed _rolled_back].each do |flag|
          value = context.instance_variable_get("@#{flag}")
          instance_variable_set("@#{flag}", value)
        end
      end
    end
  end
end
