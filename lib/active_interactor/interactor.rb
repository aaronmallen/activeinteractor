# frozen_string_literal: true

module ActiveInteractor
  # Provides interactor methods to included classes
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  module Interactor
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
      include Callbacks
      include Context
      include Execution

      private

      attr_accessor :context
    end

    module ClassMethods
      # Invoke an interactor. This is the primary public API method to an
      #  interactor.
      #
      # @example Run an interactor
      #  MyInteractor.perform(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      # @param context [Hash] properties to assign to the interactor context
      # @return [ActiveInteractor::Context::Base] an instance of context
      def perform(context = {})
        new(context).execute_perform
      end

      # Invoke an Interactor. The {.perform!} method behaves identically to
      #  the {.perform} method with one notable exception. If the context is failed
      #  during invocation of the interactor, the {ActiveInteractor::Context::Failure}
      #  is raised.
      #
      # @example Run an interactor
      #  MyInteractor.perform!(name: 'Aaron')
      #  #=> <#MyInteractor::Context name='Aaron'>
      #
      # @param context [Hash] properties to assign to the interactor context
      # @return [ActiveInteractor::Context::Base] an instance of context
      def perform!(context = {})
        new(context).execute_perform!
      end
    end

    # Whether or not the context should fail when invalid
    #  this will return false if
    #  {Interactor::Callbacks::ClassMethods#allow_context_to_be_invalid}
    #  has been invoked on the class.
    # @return [Boolean] `true` if the context should fail
    #  `false` if it should not.
    def fail_on_invalid_context?
      self.class.__fail_on_invalid_context
    end

    # Invoke an Interactor instance without any hooks, tracking, or rollback
    # @abstract It is expected that the {#perform} method is overwritten
    #  for each interactor class.
    def perform; end

    # Reverse prior invocation of an Interactor instance.
    # @abstract Any interactor class that requires undoing upon downstream
    #  failure is expected to overwrite the {#rollback} method.
    def rollback; end

    # Whether or not the context should be cleaned after {#perform}
    #  if {#skip_clean_context!} has not been invoked on the instance
    #  and {Interactor::Callbacks::ClassMethods#clean_context_on_completion}
    #  is invoked on the class this will return `true`.
    #
    # @return [Boolean] `true` if the context should be cleaned
    #  `false` if it should not be cleaned.
    def should_clean_context?
      @should_clean_context && self.class.__clean_after_perform
    end

    # Skip {ActiveInteractor::Context::Base#clean! #clean! on an interactor
    #  context that calls the {Callbacks.clean_context_on_completion} class method.
    #  This method is meant to be invoked by organizer interactors
    #  to ensure contexts are approriately passed between interactors.
    #
    # @return [Boolean] `true` if the context should be cleaned
    #  `false` if it should not.
    def skip_clean_context!
      @should_clean_context = false
    end
  end
end

Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }
