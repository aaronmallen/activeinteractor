# frozen_string_literal: true

module ActiveInteractor
  # Configurable object methods. Because {Configurable} is a module classes should include {Configurable} rather than
  # inherit from it.
  #
  # @api private
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  module Configurable
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    # Configurable object class methods. Because {ClassMethods} is a module classes should extend {ClassMethods} rather
    # than inherit from it.
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module ClassMethods
      # Get or Set the default attributes for a {Configurable} class. This method will create an `attr_accessor` on
      # the configurable class as well as set a default value for the attribute.
      #
      # @param options [Hash{Symbol=>*}, nil] the default options to set on the {Configurable} class
      # @return [Hash{Symbol=>*}] the passed options or the set defaults if no options are passed.
      def defaults(options = {})
        return __defaults if options.empty?

        options.each do |key, value|
          __defaults[key.to_sym] = value
          send(:attr_accessor, key.to_sym)
        end
      end

      private

      def __defaults
        @__defaults ||= {}
      end
    end

    # nodoc #
    # @private
    def initialize(options = {})
      self.class.defaults.merge(options).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
