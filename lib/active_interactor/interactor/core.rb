# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides ActiveInteractor::Interactor methods to included classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    #
    # @!attribute [r] context
    #  @return [ActiveInteractor::Context::Base] an instance of {ActiveInteractor::Context::Base}
    module Core
      extend ActiveSupport::Concern

      included do
        include Action
        include Callbacks
        include Context

        attr_reader :context

        # A new instance of {Core}
        # @param context [Hash, nil] the properties of the context
        # @return [Core] a new instance of {Core}
        def initialize(context = {})
          @context = self.class.context_class.build(self, context)
        end
      end
    end
  end
end
