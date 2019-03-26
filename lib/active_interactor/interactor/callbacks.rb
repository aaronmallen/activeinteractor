# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides context attribute assignment methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.1
    module Callbacks
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks

        include Context::Callbacks

        define_callbacks :perform, :rollback
      end

      class_methods do
        # Define a callback to call after {Action.perform} has been invoked
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

        # Define a callback to call after {Action#rollback} has been invoked
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

        # Define a callback to call around {Action#perform} has been invoked
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

        # Define a callback to call around {Action#rollback} has been invoked
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

        # Define a callback to call before {Action.perform} has been invoked
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

        # Define a callback to call before {Action#rollback} has been invoked
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
      end
    end
  end
end
