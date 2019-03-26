# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Interactor
    module Context
      # Provides context attribute assignment methods to included classes
      #
      # @api private
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.0.1
      # @version 0.1
      #
      # @see https://api.rubyonrails.org/classes/ActiveModel/Validations/Callbacks.html
      #  ActiveModel::Validations::Callbacks
      module Callbacks
        extend ActiveSupport::Concern

        included do
          class_attribute :__clean_after_perform, instance_writer: false, default: false
          class_attribute :__fail_on_invalid_context, instance_writer: false, default: true
          define_callbacks :validation,
                           skip_after_callbacks_if_terminated: true,
                           scope: %i[kind name]
        end

        class_methods do
          # By default an interactor context will fail if it is deemed
          #  invalid before or after the {Interactor::Action.perform} method
          #  is invoked.  Calling this method on an interactor class
          #  will not invoke {ActiveInteractor::Context::Action#fail!} if the
          #  context is invalid.
          def allow_context_to_be_invalid
            __fail_on_invalid_context = false
          end

          # Define a callback to call after `#valid?` has been invoked on an
          #  interactor's context
          #
          # @example Implement an after_context_validation callback
          #  class MyInteractor < ActiveInteractor::Base
          #    after_context_validation :ensure_name_is_aaron
          #    context_validates :name, inclusion: { in: %w[Aaron] }
          #
          #    def ensure_name_is_aaron
          #      context.name = 'Aaron'
          #    end
          #  end
          #
          #  context = MyInteractor.new(name: 'Bob').context
          #  #=> <MyInteractor::Context name='Bob'>
          #
          #  context.valid?
          #  #=> false
          #
          #  context.name
          #  #=> 'Aaron'
          #
          #  context.valid?
          #  #=> true
          def after_context_validation(*args, &block)
            options = normalize_options(args.extract_options!.dup.merge(prepend: true))
            set_callback(:validation, :after, *args, options, &block)
          end

          # Define a callback to call before `#valid?` has been invoked on an
          #  interactor's context
          #
          # @example Implement an after_context_validation callback
          #  class MyInteractor < ActiveInteractor::Base
          #    before_context_validation :set_name_aaron
          #    context_validates :name, inclusion: { in: %w[Aaron] }
          #
          #    def set_name_aaron
          #      context.name = 'Aaron'
          #    end
          #  end
          #
          #  context = MyInteractor.new(name: 'Bob').context
          #  #=> <MyInteractor::Context name='Bob'>
          #
          #  context.valid?
          #  #=> true
          #
          #  context.name
          #  #=> 'Aaron'
          def before_context_validation(*args, &block)
            options = normalize_options(args.extract_options!.dup)
            set_callback(:validation, :before, *args, options, &block)
          end

          # Calling this method on an interactor class will invoke
          #  {ActiveInteractor::Context::Attribute#clean!} on the interactor's
          #  context instance after {Interactor::Action.perform}
          #  is invoked.
          def clean_context_on_completion
            __clean_after_perform = true
          end

          private

          def normalize_options(options)
            if options.key?(:on)
              options[:on] = Array(options[:on])
              options[:if] = Array(options[:if])
              options[:if].unshift { |o| !(options[:on] & Array(o.validation_context)).empty? }
            end

            options
          end
        end
      end
    end
  end
end
