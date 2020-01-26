# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # Organizer callback methods. Because {Callbacks} is a module classes should include {Callbacks} rather than
    # inherit from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    # @see https://github.com/aaronmallen/activeinteractor/wiki/Callbacks Callbacks
    # @see https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html ActiveSupport::Callbacks
    module Callbacks
      # Organizer callback class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen
      # @since 1.0.0
      module ClassMethods
        # Define a callback to call after each {Organizer::Organize::ClassMethods#organized organized}
        # {ActiveInteractor::Base interactor's} {Interactor::Perform#perform #perform} method has been called.
        #
        # @since 0.1.3
        #
        # @example
        #  class MyInteractor1 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor1'
        #    end
        #  end
        #
        #  class MyInteractor2 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor2'
        #    end
        #  end
        #
        #  class MyOrganizer < ActiveInteractor::Organizer
        #    after_each_perform :print_done
        #
        #    organized MyInteractor1, MyInteractor2
        #
        #    private
        #
        #    def print_done
        #      puts 'Done'
        #    end
        #  end
        #
        #  MyOrganizer.perform
        #  "MyInteractor1"
        #  "Done"
        #  "MyInteractor2"
        #  "Done"
        #  #=> <MyOrganizer::Context>
        def after_each_perform(*filters, &block)
          set_callback(:each_perform, :after, *filters, &block)
        end

        # Define a callback to call around each {Organizer::Organize::ClassMethods#organized organized}
        # {ActiveInteractor::Base interactor's} {Interactor::Perform#perform #perform} method call.
        #
        # @since 0.1.3
        #
        # @example
        #  class MyInteractor1 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor1'
        #      sleep(1)
        #    end
        #  end
        #
        #  class MyInteractor2 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor2'
        #      sleep(1)
        #    end
        #  end
        #
        #  class MyOrganizer < ActiveInteractor::Organizer
        #    around_each_perform :print_time
        #
        #    organized MyInteractor1, MyInteractor2
        #
        #    private
        #
        #    def print_time
        #      puts Time.now.utc
        #      yield
        #      puts Time.now.utc
        #    end
        #  end
        #
        #  MyOrganizer.perform
        #  "2019-04-01 00:00:00 UTC"
        #  "MyInteractor1"
        #  "2019-04-01 00:00:01 UTC"
        #  "2019-04-01 00:00:01 UTC"
        #  "MyInteractor2"
        #  "2019-04-01 00:00:02 UTC"
        #  #=> <MyOrganizer::Context>
        def around_each_perform(*filters, &block)
          set_callback(:each_perform, :around, *filters, &block)
        end

        # Define a callback to call before each {Organizer::Organize::ClassMethods#organized organized}
        # {ActiveInteractor::Base interactor's} {Interactor::Perform#perform #perform} method has been called.
        #
        # @since 0.1.3
        #
        # @example
        #  class MyInteractor1 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor1'
        #    end
        #  end
        #
        #  class MyInteractor2 < ActiveInteractor::Base
        #    def perform
        #      puts 'MyInteractor2'
        #    end
        #  end
        #
        #  class MyOrganizer < ActiveInteractor::Organizer
        #    before_each_perform :print_starting
        #
        #    organized MyInteractor1, MyInteractor2
        #
        #    private
        #
        #    def print_starting
        #      puts 'Starting'
        #    end
        #  end
        #
        #  MyOrganizer.perform
        #  "Starting"
        #  "MyInteractor1"
        #  "Starting"
        #  "MyInteractor2"
        #  #=> <MyOrganizer::Context>
        def before_each_perform(*filters, &block)
          set_callback(:each_perform, :before, *filters, &block)
        end
      end

      def self.included(base)
        base.class_eval do
          define_callbacks :each_perform
        end
      end
    end
  end
end
