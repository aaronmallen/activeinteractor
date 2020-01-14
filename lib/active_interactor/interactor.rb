# frozen_string_literal: true

module ActiveInteractor
  # Interactor methods. {Base} includes {Interactor} all interactors
  #  should inherit from {Base}.
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  module Interactor
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include Callbacks
        include Context
        delegate :execute_perform, :execute_perform!, to: :worker
      end
    end

    # Interactor class methods.
    module ClassMethods
      # Run an interactor context.  This it the primary API method for
      # interacting with interactors.
      # @example Run an interactor
      #  MyInteractor.perform(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      # @param context [Hash|Context::Base] attributes to assign to the interactor context
      # @param options [Hash] execution options for the interactor perform step
      #   see {PerformOptions}
      # @return [Context::Base] an instance of context.
      def perform(context = {}, options = {})
        new(context).with_options(options).execute_perform
      end

      # Run an interactor context. The {.perform!} method behaves identically to
      #  the {.perform} method with one notable exception. If the context is failed
      #  during invocation of the interactor, the {Error::ContextFailure}
      #  is raised.
      # @example Run an interactor
      #  MyInteractor.perform!(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      # @param context [Hash|Context::Base] attributes to assign to the interactor context
      # @param options [Hash] execution options for the interactor perform step
      #   see {PerformOptions}
      # @raise [Error::ContextFailure] if the context fails.
      # @return [Context::Base] an instance of context.
      def perform!(context = {}, options = {})
        new(context).with_options(options).execute_perform!
      end
    end

    # Options for invokation of {#perform}
    # @return [PerformOptions] the options
    def options
      @options ||= PerformOptions.new
    end

    # Invoke an Interactor instance without any hooks, tracking, or rollback
    # @abstract It is expected that the {#perform} method is overwritten
    #  for each interactor class.
    def perform; end

    # Reverse prior invocation of an Interactor instance.
    # @abstract Any interactor class that requires undoing upon downstream
    #  failure is expected to overwrite the {#rollback} method.
    def rollback; end

    # Set options for invokation of {#perform}
    # @param options [PerformOptions|Hash] the perform options
    # @return [Base] the instance of {Base}
    def with_options(options)
      @options = options.is_a?(PerformOptions) ? options : PerformOptions.new(options)
      self
    end

    private

    def worker
      Worker.new(self)
    end
  end
end

Dir[File.expand_path('interactor/*.rb', __dir__)].sort.each { |file| require file }
