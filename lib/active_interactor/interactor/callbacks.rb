# frozen_string_literal: true

require 'active_support/callbacks'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module ActiveInteractor
  module Interactor
    # Interactor callback methods included by all {Base}
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    module Callbacks
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          include ActiveSupport::Callbacks

          define_callbacks :validation,
                           skip_after_callbacks_if_terminated: true,
                           scope: %i[kind name]
          define_callbacks :perform, :rollback
        end
      end

      # Interactor callback class methods extended by all {Base}
      module ClassMethods
        # Define a callback to call after {ActiveInteractor::Context::Base#valid? #valid?} has been invoked on an
        #  interactor's context
        # @example Implement an after_context_validation callback
        #  class MyInteractor < ActiveInteractor::Base
        #    after_context_validation :downcase_name
        #
        #    private
        #
        #    def downcase_name
        #      context.name.downcase!
        #    end
        #  end
        #
        #  result = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='aaron'>
        #
        #  result.valid?
        #  #=> true
        #
        #  result.name
        #  #=> 'aaron'
        def after_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup.merge(prepend: true))
          set_callback(:validation, :after, *args, options, &block)
        end

        # Define a callback to call after {Interactor#perform #perform} has been invoked
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    after_perform :print_done
        #
        #    def perform
        #      puts 'Performing'
        #    end
        #
        #    private
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

        # Define a callback to call after {Interactor#rollback #rollback} has been invoked
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    after_rollback :print_done
        #
        #    def perform
        #      context.fail!
        #    end
        #
        #    def rollback
        #      puts 'Rolling back'
        #    end
        #
        #    private
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

        # Define a callback to call around {Interactor#perform #perform} invokation
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    around_perform :track_time
        #
        #    def perform
        #      sleep(1)
        #    end
        #
        #    private
        #
        #    def track_time
        #      context.start_time = Time.now.utc
        #      yield
        #      context.end_time = Time.now.utc
        #    end
        #  end
        #
        #  result = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  result.start_time
        #  #=> 2019-01-01 00:00:00 UTC
        #
        #  result.end_time
        #  #=> 2019-01-01 00:00:01 UTC
        def around_perform(*filters, &block)
          set_callback(:perform, :around, *filters, &block)
        end

        # Define a callback to call around {Interactor#rollback #rollback} invokation
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    around_rollback :track_time
        #
        #    def rollback
        #      sleep(1)
        #    end
        #
        #    private
        #
        #    def track_time
        #      context.start_time = Time.now.utc
        #      yield
        #      context.end_time = Time.now.utc
        #    end
        #  end
        #
        #  result = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='Aaron'>
        #
        #  result.rollback!
        #  #=> true
        #
        #  result.start_time
        #  #=> 2019-01-01 00:00:00 UTC
        #
        #  result.end_time
        #  #=> 2019-01-01 00:00:01 UTC
        def around_rollback(*filters, &block)
          set_callback(:rollback, :around, *filters, &block)
        end

        # Define a callback to call before {ActiveInteractor::Context::Base#valid? #valid?} has been invoked on an
        #  interactor's context
        # @example Implement an after_context_validation callback
        #  class MyInteractor < ActiveInteractor::Base
        #    before_context_validation :downcase_name
        #
        #    private
        #
        #    def downcase_name
        #      context.name.downcase!
        #    end
        #  end
        #
        #  result = MyInteractor.perform(name: 'Aaron')
        #  #=> <MyInteractor::Context name='aaron'>
        #
        #  result.valid?
        #  #=> true
        #
        #  result.name
        #  #=> 'aaron'
        def before_context_validation(*args, &block)
          options = normalize_options(args.extract_options!.dup)
          set_callback(:validation, :before, *args, options, &block)
        end

        # Define a callback to call before {Interactor#perform #perform} has been invoked
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    before_perform :print_start
        #
        #    def perform
        #      puts 'Performing'
        #    end
        #
        #    private
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

        # Define a callback to call before {Interactor#rollback #rollback} has been invoked
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #    before_rollback :print_start
        #
        #    def rollback
        #      puts 'Rolling Back'
        #    end
        #
        #    private
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
