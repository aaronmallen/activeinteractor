# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    module Callbacks
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks

        include Context::Callbacks

        define_callbacks :perform, :rollback
      end

      class_methods do
        def after_perform(*filters, &block)
          set_callback(:perform, :after, *filters, &block)
        end

        def after_rollback(*filters, &block)
          set_callback(:rollback, :after, *filters, &block)
        end

        def around_perform(*filters, &block)
          set_callback(:perform, :around, *filters, &block)
        end

        def around_rollback(*filters, &block)
          set_callback(:rollback, :around, *filters, &block)
        end

        def before_perform(*filters, &block)
          set_callback(:perform, :before, *filters, &block)
        end

        def before_rollback(*filters, &block)
          set_callback(:rollback, :before, *filters, &block)
        end
      end
    end
  end
end
