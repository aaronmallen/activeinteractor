# frozen_string_literal: true

require 'active_model'
require 'active_support/callbacks'
require 'active_support/concern'
require 'active_support/core_ext/module'
require 'ostruct'

require_relative './input_context'
require_relative './interactor_options'
require_relative './output_context'
require_relative './status'
require_relative './worker'

module ActiveInteractor
  class Interactor
    module CallbackMethods
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks

        define_callbacks :input_validation,
                         skip_after_callbacks_if_terminated: true,
                         scope: %i[kind name]
        define_callbacks :output_validation,
                         skip_after_callbacks_if_terminated: true,
                         scope: %i[kind name]
        define_callbacks :build_input_context,
                         :build_output_context,
                         :build_runtime_context,
                         :failure,
                         :perform,
                         :rollback
      end

      module ClassMethods
        def after_build_input_context(*filters, &block)
          set_callback(:build_input_context, :after, *filters, &block)
        end

        def after_build_output_context(*filters, &block)
          set_callback(:build_output_context, :after, *filters, &block)
        end

        def after_build_runtime_context(*filters, &block)
          set_callback(:build_runtime_context, :after, *filters, &block)
        end

        def after_failure(*filters, &block)
          set_callback(:failure, :after, *filters, &block)
        end

        def after_input_validation(*args, &block)
          options = normalize_callback_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:input_validation, :after, *args, options, &block)
        end

        def after_output_validation(*args, &block)
          options = normalize_callback_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:output_validation, :after, *args, options, &block)
        end

        def after_perform(*filters, &block)
          set_callback(:perform, :after, *filters, &block)
        end

        def after_rollback(*filters, &block)
          set_callback(:rollback, :after, *filters, &block)
        end

        def around_build_input_context(*filters, &block)
          set_callback(:build_input_context, :around, *filters, &block)
        end

        def around_build_output_context(*filters, &block)
          set_callback(:build_output_context, :around, *filters, &block)
        end

        def around_build_runtime_context(*filters, &block)
          set_callback(:build_runtime_context, :around, *filters, &block)
        end

        def around_failure(*filters, &block)
          set_callback(:failure, :around, *filters, &block)
        end

        def around_perform(*filters, &block)
          set_callback(:perform, :around, *filters, &block)
        end

        def around_rollback(*filters, &block)
          set_callback(:rollback, :around, *filters, &block)
        end

        def before_build_input_context(*filters, &block)
          set_callback(:build_input_context, :before, *filters, &block)
        end

        def before_build_output_context(*filters, &block)
          set_callback(:build_output_context, :before, *filters, &block)
        end

        def before_build_runtime_context(*filters, &block)
          set_callback(:build_runtime_context, :before, *filters, &block)
        end

        def before_failure(*filters, &block)
          set_callback(:failure, :before, *filters, &block)
        end

        def before_input_validation(*args, &block)
          options = normalize_callback_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:input_validation, :before, *args, options, &block)
        end

        def before_output_validation(*args, &block)
          options = normalize_callback_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:output_validation, :before, *args, options, &block)
        end

        def before_perform(*filters, &block)
          set_callback(:perform, :before, *filters, &block)
        end

        def before_rollback(*filters, &block)
          set_callback(:rollback, :before, *filters, &block)
        end

        private

        def normalize_callback_options(options)
          if options.key?(:on)
            options[:on] = Array(options[:on])
            options[:if] = Array(options[:if])
            options[:if].unshift { |o| !(options[:on] & Array(o.validation_context)).empty? }
          end

          options
        end
      end
    end

    module ContextMethods
      extend ActiveSupport::Concern

      included do
        attr_reader :input_context, :output_context

        private

        attr_reader :context
      end

      module ClassMethods
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :input_type, prefix: :input)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :input_type, prefix: :input)
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :output_type, prefix: :output)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :output_type, prefix: :output)
        delegate :argument, to: :input_type
        delegate :returns, to: :output_type

        def input_type(new_input_type = nil)
          @input_type = new_input_type if new_input_type
          @input_type ||= default_input_type
        end

        def output_type(new_output_type = nil)
          @output_type = new_output_type if new_output_type
          @output_type ||= default_output_type
        end

        private

        def default_input_type
          @default_input_type ||= const_set('InputContext', Class.new(InputContext))
        end

        def default_output_type
          @default_output_type ||= const_set('OutputContext', Class.new(OutputContext))
        end
      end

      def initialize_input_context
        @input_context = self.class.input_type.new(@input_context_attributes.dup)
      end

      def initialize_output_context
        @output_context = self.class.output_type.new(runtime_context.to_h)
      end

      def initialize_runtime_context
        @context = OpenStruct.new(input_context.dup.attributes.to_hash)
      end

      def runtime_context
        @context.deep_dup
      end
    end

    include CallbackMethods
    include ContextMethods
    attr_reader :options, :status

    def self.perform(input_context_attributes = {})
      new.perform(input_context_attributes)
    end

    def self.with_options(*options)
      new.with_options(*options)
    end

    def self.with_status(status)
      new.with_status(status)
    end

    def initialize
      @status = Status.new
    end

    def deep_dup
      dup.with_options(@options.dup).with_status(@status.dup)
    end

    def interaction; end

    def perform(input_context_attributes = {})
      @input_context_attributes = input_context_attributes
      Worker.new(self).execute_interaction
    end

    def rollback; end

    def with_options(*options)
      @options = if options.count == 1 && options.first.is_a?(InteractorOptions)
                   options.first
                 else
                   InteractorOptions.new(*options)
                 end

      self
    end

    def with_status(status)
      @status = status
      self
    end
  end
end
