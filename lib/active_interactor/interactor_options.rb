# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'

module ActiveInteractor
  class InteractorOptions
    DEFAULTS = {
      skip_build_input_context_callbacks: false,
      skip_build_output_context_callbacks: false,
      skip_build_runtime_context_callbacks: false,
      skip_failure_callbacks: false,
      skip_input_validation_callbacks: false,
      skip_output_validation_callbacks: false,
      skip_perform_callbacks: false,
      skip_rollback: false,
      skip_rollback_callbacks: false,
      validate_input: true,
      validate_output: true
    }.freeze

    def initialize(*args)
      options = args.extract_options!
      instance_toggles_set(args)
      instance_options_set(options)
    end

    private

    def method_missing(method_name, *args, &block)
      boolean_method = method_name[/.*(?=\?\z)/m]
      if DEFAULTS.key?(boolean_method&.to_sym)
        instance_variable_get("@#{boolean_method}")
      else
        super
      end
    end

    def instance_options_set(options)
      DEFAULTS.merge(options.select { |name, _value| DEFAULTS.key?(name) }).each do |name, value|
        next if instance_variable_defined?("@#{name}".to_sym)

        instance_variable_set("@#{name}", value)
      end
    end

    def instance_toggles_set(toggles)
      toggles
        .select { |toggle| DEFAULTS.key?(toggle) }
        .each { |toggle| instance_variable_set("@#{toggle}", !DEFAULTS[toggle]) }
    end

    def respond_to_missing?(method_name, include_private = false)
      boolean_method = method_name[/.*(?=\?\z)/m]
      return true if DEFAULTS.key?(boolean_method&.to_sym)

      super
    end
  end
end
