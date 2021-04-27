# frozen_string_literal: true

require 'active_support/core_ext/module'

module ActiveInteractor
  class Result
    attr_reader :input_context, :output_context, :runtime_context, :status

    delegate :fail?, :failure?, :success?, :successful?, to: :status

    def initialize(status:, input_context: nil, runtime_context: nil, output_context: nil)
      @input_context = input_context
      @output_context = output_context
      @runtime_context = runtime_context
      @status = status
    end

    def context
      context_instance&.attributes
    end

    def errors
      context_instance&.errors
    end

    private

    def context_instance
      @context_instance ||= if status.failed_on_input?
                              input_context
                            elsif status.failed_on_runtime?
                              runtime_context
                            else
                              output_context
                            end
    end

    def method_missing(method_name, *args, &block)
      if !method_name[/.*(?==\z)/m] && context_instance.respond_to?(method_name)
        return context_instance.send(method_name)
      end

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      return true if !method_name[/.*(?==\z)/m] && context_instance.respond_to?(method_name)

      super
    end
  end
end
