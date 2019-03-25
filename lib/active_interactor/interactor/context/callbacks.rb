# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'

module ActiveInteractor
  module Interactor
    module Context
      module Callbacks
        extend ActiveSupport::Concern

        included do
          define_callbacks :validation,
                           skip_after_callbacks_if_terminated: true,
                           scope: %i[kind name]
        end

        class_methods do
          def after_context_validation(*args, &block)
            options = normalize_options(args.extract_options!.dup.merge(prepend: true))
            set_callback(:validation, :after, *args, options, &block)
          end

          def before_context_validation(*args, &block)
            options = normalize_options(args.extract_options!.dup)
            set_callback(:validation, :before, *args, options, &block)
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
