# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Context
      # Generates a subclass on an Interactor class called `Context`
      #
      # @api private
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.0.1
      # @version 0.1
      module Generation
        extend ActiveSupport::Concern

        included do
          const_set 'Context', Class.new(ActiveInteractor::Context::Base)
        end

        class_methods do
          # The context class of the interactor
          #
          # @example
          #  class MyInteractor < ActiveInteractor::Base
          #  end
          #
          #  MyInteractor.context_class
          #  #=> MyInteractor::Context
          def context_class
            const_get 'Context'
          end
        end
      end
    end
  end
end
