# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Interactor
    # Provides context attribute assignment methods to included classes
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Callbacks
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        include ActiveSupport::Callbacks

        class_attribute :__clean_after_perform, instance_writer: false, default: false
        class_attribute :__fail_on_invalid_context, instance_writer: false, default: true
        define_callbacks :validation,
                         skip_after_callbacks_if_terminated: true,
                         scope: %i[kind name]
        define_callbacks :perform, :rollback
      end

      module ClassMethods
        # Define a callback to call after `#valid?` has been invoked on an
        #  interactor's context
        #
        # @example Implement an after_context_validation callback
        #  class MyInteractor < ActiveInteractor::Base
        #    after_context_validation :ensure_name_is_aaron
        #    context_validates :name, inclusion: { in: %w[Aaron] }
        #
        #    def ensure_name_is_aaron
        #      context.name = 'Aaron'
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Bob')
        #  #=> <MyInteractor::Context name='Bob'>
        #
        #  context.valid?
        #  #=> false
        #
        #  context.name
        #  #=> 'Aaron'
        #
        #  context.valid?
        #  #=> true
        def after_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:validation, :after, *args, options, &block)
        end

        # Define a callback to call after {ActiveInteractor::Base.perform} has been invoked
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    after_perform :print_done
        #
        #    def perform
        #      puts 'Performing'
        #    end
        #
        #    def print_done
        #      puts 'Done'
        #    end
        #  end
        #
        #  MyInteractor.perform(name: 'Aaron')
        #  "Performing"
        #  "Done"
        #  #=> <MyInteractor::Context name='Aaron'>
        def after_perform(*filters, &block)
          set_callback(:perform, :after, *filters, &block)
        end

        # Define a callback to call after {ActiveInteractor::Base#rollback} has been invoked
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    after_rollback :print_done
        #
        #    def rollback
        #      puts 'Rolling back'
        #    end
        #
        #    def print_done
        #      puts 'Done'
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  context.rollback!
        #  "Rolling back"
        #  "Done"
        def after_rollback(*filters, &block)
          set_callback(:rollback, :after, *filters, &block)
        end

        # By default an interactor context will fail if it is deemed
        #  invalid before or after the {ActiveInteractor::Base.perform} method
        #  is invoked.  Calling this method on an interactor class
        #  will not invoke {ActiveInteractor::Context::Base#fail!} if the
        #  context is invalid.
        def allow_context_to_be_invalid
          self.__fail_on_invalid_context = false
        end

        # Define a callback to call around {ActiveInteractor::Base.perform} invokation
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    around_perform :track_time
        #
        #    def perform
        #      sleep(1)
        #    end
        #
        #    def track_time
        #      context.start_time = Time.now.utc
        #      yield
        #      context.end_time = Time.now.utc
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  context.start_time
        #  #=> 2019-01-01 00:00:00 UTC
        #
        #  context.end_time
        #  #=> 2019-01-01 00:00:01 UTC
        def around_perform(*filters, &block)
          set_callback(:perform, :around, *filters, &block)
        end

        # Define a callback to call around {ActiveInteractor::Base#rollback} invokation
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    around_rollback :track_time
        #
        #    def rollback
        #      sleep(1)
        #    end
        #
        #    def track_time
        #      context.start_time = Time.now.utc
        #      yield
        #      context.end_time = Time.now.utc
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  context.rollback!
        #  #=> true
        #
        #  context.start_time
        #  #=> 2019-01-01 00:00:00 UTC
        #
        #  context.end_time
        #  #=> 2019-01-01 00:00:01 UTC
        def around_rollback(*filters, &block)
          set_callback(:rollback, :around, *filters, &block)
        end

        # Define a callback to call before `#valid?` has been invoked on an
        #  interactor's context
        #
        # @example Implement an after_context_validation callback
        #  class MyInteractor < ActiveInteractor::Base
        #    before_context_validation :set_name_aaron
        #    context_validates :name, inclusion: { in: %w[Aaron] }
        #
        #    def set_name_aaron
        #      context.name = 'Aaron'
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Bob')
        #  #=> <MyInteractor::Context name='Bob'>
        #
        #  context.valid?
        #  #=> true
        #
        #  context.name
        #  #=> 'Aaron'
        def before_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup)
          set_callback(:validation, :before, *args, options, &block)
        end

        # Define a callback to call before {ActiveInteractor::Base.perform} has been invoked
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    before_perform :print_start
        #
        #    def perform
        #      puts 'Performing'
        #    end
        #
        #    def print_start
        #      puts 'Start'
        #    end
        #  end
        #
        #  MyInteractor.perform(name: 'Aaron')
        #  "Start"
        #  "Performing"
        #  #=> <MyInteractor::Context name='Aaron'>
        def before_perform(*filters, &block)
          set_callback(:perform, :before, *filters, &block)
        end

        # Define a callback to call before {ActiveInteractor::Base#rollback} has been invoked
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    before_rollback :print_start
        #
        #    def rollback
        #      puts 'Rolling Back'
        #    end
        #
        #    def print_start
        #      puts 'Start'
        #    end
        #  end
        #
        #  context = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  context.rollback!
        #  "Start"
        #  "Rolling Back"
        #  #=> true
        def before_rollback(*filters, &block)
          set_callback(:rollback, :before, *filters, &block)
        end

        # Calling this method on an interactor class will invoke
        #  {ActiveInteractor::Context::Base#clean!} on the interactor's
        #  context instance after {ActiveInteractor::Base.perform}
        #  is invoked.
        def clean_context_on_completion
          self.__clean_after_perform = true
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
    end
  end
end
