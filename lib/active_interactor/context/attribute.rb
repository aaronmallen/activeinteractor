# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Context
    module Attribute
      extend ActiveSupport::Concern

      included do
        class_attribute :__default_attributes, instance_writer: false, default: []
      end

      class_methods do
        def attributes
          __default_attributes
        end

        def attributes=(*attributes)
          __default_attributes.concat(attributes.flatten.map(&:to_sym)).flatten.uniq
        end
      end

      def attributes
        self.class.attributes.each_with_object({}) do |attribute, hash|
          hash[attribute] = self[attribute] if self[attribute]
        end
      end

      def clean!
        deleted = {}
        keys.reject { |key| self.class.attributes.include?(key) }.each do |attribute|
          deleted[attribute] = self[attribute] if self[attribute]
          delete_field(key.to_s)
        end
        deleted
      end

      def keys
        each_pair { |pair| pair[0].to_sym }
      end
    end
  end
end
