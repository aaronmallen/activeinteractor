# frozen_string_literal: true

module ActiveInteractor
  # The Base Interactor class inherited by all interactors
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  class Base
    include Interactor
    # A new instance of {Base}
    # @param context [Hash, nil] the properties of the context
    # @return [ActiveInteractor::Base] a new instance of {Base}
    def initialize(context = {})
      @context = self.class.context_class.new(self, context)
      @worker = ActiveInteractor::Interactor::Worker.new(self, worker_options)
    end
  end
end
