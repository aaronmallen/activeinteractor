# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Interactor callback methods. Because {Callbacks} is a module classes should include {Callbacks} rather than
    # inherit from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.0
    # @see https://github.com/aaronmallen/activeinteractor/wiki/Callbacks Callbacks
    # @see https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html ActiveSupport::Callbacks
    module Callbacks
      # Interactor callback class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen
      # @since 0.1.0
      module ClassMethods
        # Define a callback to call after validation has been run on an {Base interactor} instance's
        # {ActiveInteractor::Context::Base context} instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     after_context_validation :ensure_name_is_aaron
        #     context_validates :name, presence: true
        #
        #     private
        #
        #     def ensure_name_is_aaron
        #       context.name = 'Aaron'
        #     end
        #   end
        #
        #   result = MyInteractor.perform(name: 'Bob')
        #   result.name
        #   #=> 'Aaron'
        #
        #   result = MyInteractor.perform({ name: 'Bob' }, { validate: false })
        #   result.name
        #   #=> 'Bob'
        def after_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:validation, :after, *args, options, &block)
        end

        # Define a callback to call after {Interactor::Perform#perform #perform} has been called on an
        # {Base interactor} instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     after_perform :print_done
        #
        #     def perform
        #       puts 'Performing'
        #     end
        #
        #     private
        #
        #     def print_done
        #       puts 'Done'
        #     end
        #   end
        #
        #   MyInteractor.perform
        #   "Performing"
        #   "Done"
        #   #=> <#MyInteractor::Context>
        def after_perform(*filters, &block)
          set_callback(:perform, :after, *filters, &block)
        end

        # Define a callback to call after {Interactor::Perform#rollback #rollback} has been called on an
        # {Base interactor} instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     after_rollback :print_done
        #
        #     def perform
        #       context.fail!
        #     end
        #
        #     def rollback
        #       puts 'Rolling Back'
        #     end
        #
        #     private
        #
        #     def print_done
        #       puts 'Done'
        #     end
        #   end
        #
        #   MyInteractor.perform
        #   "Rolling Back"
        #   "Done"
        #   #=> <MyInteractor::Context>
        def after_rollback(*filters, &block)
          set_callback(:rollback, :after, *filters, &block)
        end

        # Define a callback to call around {Interactor::Perform#perform #perform} invokation on an {Base interactor}
        # instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     around_perform :track_time
        #
        #     def perform
        #       sleep(1)
        #     end
        #
        #     private
        #
        #     def track_time
        #       context.start_time = Time.now.utc
        #       yield
        #       context.end_time = Time.now.utc
        #     end
        #   end
        #
        #   result = MyInteractor.perform
        #   result.start_time
        #   #=> 2019-01-01 00:00:00 UTC
        #
        #   result.end_time
        #   #=> 2019-01-01 00:00:01 UTC
        def around_perform(*filters, &block)
          set_callback(:perform, :around, *filters, &block)
        end

        # Define a callback to call around {Interactor::Perform#rollback #rollback} invokation on an {Base interactor}
        # instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     around_rollback :track_time
        #
        #     def perform
        #       context.fail!
        #     end
        #
        #     def rollback
        #       sleep(1)
        #     end
        #
        #     private
        #
        #     def track_time
        #       context.start_time = Time.now.utc
        #       yield
        #       context.end_time = Time.now.utc
        #     end
        #   end
        #
        #   result = MyInteractor.perform
        #   result.start_time
        #   #=> 2019-01-01 00:00:00 UTC
        #
        #   result.end_time
        #   #=> 2019-01-01 00:00:01 UTC
        def around_rollback(*filters, &block)
          set_callback(:rollback, :around, *filters, &block)
        end

        # Define a callback to call before validation has been run on an {Base interactor} instance's
        # {ActiveInteractor::Context::Base context} instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     before_context_validation :ensure_name_is_aaron
        #     context_validates :name, inclusion: { in: %w[Aaron] }
        #
        #     private
        #
        #     def ensure_name_is_aaron
        #       context.name = 'Aaron'
        #     end
        #   end
        #
        #   result = MyInteractor.perform(name: 'Bob')
        #   result.successful?
        #   #=> true
        #
        #   result.name
        #   #=> 'Aaron'
        #
        #   result = MyInteractor.perform({ name: 'Bob' }, { validate: false })
        #   result.name
        #   #=> 'Bob'
        def before_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup)
          set_callback(:validation, :before, *args, options, &block)
        end

        # Define a callback to call before {Interactor::Perform#perform #perform} has been called on an
        # {Base interactor} instance
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     before_perform :print_starting
        #
        #     def perform
        #       puts 'Performing'
        #     end
        #
        #     private
        #
        #     def print_starting
        #       puts 'Starting'
        #     end
        #   end
        #
        #   MyInteractor.perform
        #   "Starting"
        #   "Performing"
        #   #=> <#MyInteractor::Context>
        def before_perform(*filters, &block)
          set_callback(:perform, :before, *filters, &block)
        end

        # Define a callback to call before {Interactor::Perform#rollback #rollback} has been called on an
        # {Base interactor} instance.
        #
        # @example
        #   class MyInteractor < ActiveInteractor::Base
        #     before_rollback :print_starting
        #
        #     def perform
        #       context.fail!
        #     end
        #
        #     def rollback
        #       puts 'Rolling Back'
        #     end
        #
        #     private
        #
        #     def print_starting
        #       puts 'Starting'
        #     end
        #   end
        #
        #   MyInteractor.perform
        #   "Starting"
        #   "Rolling Back"
        #   #=> <#MyInteractor::Context>
        def before_rollback(*filters, &block)
          set_callback(:rollback, :before, *filters, &block)
        end

        # Set {.after_callbacks_deferred_when_organized} to `true`
        #
        # @since v1.2.0
        #
        # @example a basic {Base organizer} set to defer 'after' callbacks when organized
        #   class MyOrganizer < ActiveInteractor::Organizer::Base
        #     defer_after_callbacks_when_organized
        #   end
        def defer_after_callbacks_when_organized
          self.after_callbacks_deferred_when_organized = true
        end

        def self.extended(base)
          base.class_eval do
            class_attribute :after_callbacks_deferred_when_organized, instance_writer: false, default: false
          end
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

      def self.included(base)
        base.class_eval do
          define_callbacks :validation,
                           skip_after_callbacks_if_terminated: true,
                           scope: %i[kind name]
          define_callbacks :perform, :rollback
        end
      end
    end
  end
end
