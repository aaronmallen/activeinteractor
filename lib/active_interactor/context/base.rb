# frozen_string_literal: true

require 'active_model'
require 'ostruct'

require 'active_interactor/context/attributes'

module ActiveInteractor
  module Context
    # The base context class.  All interactor contexts should inherit from
    #  {Context::Base}.
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    class Base < OpenStruct
      include ActiveModel::Validations
      include Attributes
      include Status

      # @param context [Hash|Context::Base] attributes to assign to the context
      # @return [Context::Base] a new instance of {Context::Base}
      def initialize(context = {})
        merge_errors!(context.errors) if context.respond_to?(:errors)
        copy_flags!(context)
        copy_called!(context)
        super
      end

      # @!method valid?(context = nil)
      # @see
      #   https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations.rb#L305
      #   ActiveModel::Validations#valid?

      # Merge an instance of context or a hash into an existing context
      # @since 1.0.0
      # @example
      #   class MyInteractor1 < ActiveInteractor::Base
      #     def perform
      #       context.first_name = 'Aaron'
      #     end
      #   end
      #
      #  class MyInteractor2 < ActiveInteractor::Base
      #    def perform
      #      context.last_name = 'Allen'
      #    end
      #  end
      #
      #  result = MyInteractor1.perform
      #  #=> <#MyInteractor1::Context first_name='Aaron'>
      #
      #  result.merge!(MyInteractor2.perform)
      #  #=> <#MyInteractor1::Context first_name='Aaron' last_name='Allen'>
      # @param context [Base|Hash] attributes to merge into the context
      # @return [Base] an instance of {Base}
      def merge!(context)
        merge_errors!(context.errors) if context.respond_to?(:errors)
        copy_flags!(context)
        context.each_pair do |key, value|
          self[key] = value
        end
        self
      end

      private

      def merge_errors!(errors)
        if errors.is_a? String
          self.errors.add(:context, errors)
        else
          self.errors.merge!(errors)
        end
      end
    end
  end
end
