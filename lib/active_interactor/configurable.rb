# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  # Methods for configurable objects
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 1.0.0
  module Configurable
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    # Class methods for configuable objects
    module ClassMethods
      # Set or get default options for a configurable object
      # @param options [Hash] the options to set for defaults
      # @return [Hash] the defaults
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

    # @param options [Hash] the options for the configuration
    # @return [Configurable] a new instance of {Configurable}
    def initialize(options = {})
      self.class.defaults.merge(options).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
