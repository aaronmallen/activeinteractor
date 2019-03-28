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

    # Invoke an Interactor instance without any hooks, tracking, or rollback
    # @abstract It is expected that the {#perform} method is overwritten
    #  for each interactor class.
    def perform; end

    # Reverse prior invocation of an Interactor instance.
    # @abstract Any interactor class that requires undoing upon downstream
    #  failure is expected to overwrite the {#rollback} method.
    def rollback; end
  end
end

Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }
