# frozen_string_literal: true

module ActiveInteractor
  # The Base Interactor class inherited by all Interactor::Organizers
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.3
  class Organizer < ActiveInteractor::Base
    define_callbacks :each_perform

    class << self
      # Define a callback to call after each organized interactor's
      #  {ActiveInteractor::Base.perform} has been invoked
      #
      # @example
      #  class MyInteractor1 < ActiveInteractor::Base
      #    before_perform :print_name
      #
      #    def perform
      #      puts 'MyInteractor1'
      #    end
      #  end
      #
      #  class MyInteractor2 < ActiveInteractor::Base
      #    before_perform :print_name
      #
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
      #      puts "done"
      #    end
      #  end
      #
      #  MyOrganizer.perform(name: 'Aaron')
      #  "MyInteractor1"
      #  "Done"
      #  "MyInteractor2"
      #  "Done"
      #  #=> <MyOrganizer::Context name='Aaron'>
      def after_each_perform(*filters, &block)
        set_callback(:each_perform, :after, *filters, &block)
      end

      # Define a callback to call around each organized interactor's
      #  {ActiveInteractor::Base.perform} has been invokation
      #
      # @example
      #  class MyInteractor1 < ActiveInteractor::Base
      #    before_perform :print_name
      #
      #    def perform
      #      puts 'MyInteractor1'
      #    end
      #  end
      #
      #  class MyInteractor2 < ActiveInteractor::Base
      #    before_perform :print_name
      #
      #    def perform
      #      puts 'MyInteractor2'
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
      #  MyOrganizer.perform(name: 'Aaron')
      #  "2019-04-01 00:00:00 UTC"
      #  "MyInteractor1"
      #  "2019-04-01 00:00:01 UTC"
      #  "2019-04-01 00:00:02 UTC"
      #  "MyInteractor2"
      #  "2019-04-01 00:00:03 UTC"
      #  #=> <MyOrganizer::Context name='Aaron'>
      def around_each_perform(*filters, &block)
        set_callback(:each_perform, :around, *filters, &block)
      end

      # Define a callback to call before each organized interactor's
      #  {ActiveInteractor::Base.perform} has been invoked
      #
      # @example
      #  class MyInteractor1 < ActiveInteractor::Base
      #    before_perform :print_name
      #
      #    def perform
      #      puts 'MyInteractor1'
      #    end
      #  end
      #
      #  class MyInteractor2 < ActiveInteractor::Base
      #    before_perform :print_name
      #
      #    def perform
      #      puts 'MyInteractor2'
      #    end
      #  end
      #
      #  class MyOrganizer < ActiveInteractor::Organizer
      #    before_each_perform :print_start
      #
      #    organized MyInteractor1, MyInteractor2
      #
      #    private
      #
      #    def print_start
      #      puts "Start"
      #    end
      #  end
      #
      #  MyOrganizer.perform(name: 'Aaron')
      #  "Start"
      #  "MyInteractor1"
      #  "Start"
      #  "MyInteractor2"
      #  #=> <MyOrganizer::Context name='Aaron'>
      def before_each_perform(*filters, &block)
        set_callback(:each_perform, :before, *filters, &block)
      end

      # Declare Interactors to be invoked as part of the
      #  organizer's invocation. These interactors are invoked in
      #  the order in which they are declared
      #
      # @example
      #   class MyFirstOrganizer < ActiveInteractor::Organizer
      #     organize InteractorOne, InteractorTwo
      #   end
      #
      #   class MySecondOrganizer < ActiveInteractor::Organizer
      #     organize [InteractorThree, InteractorFour]
      #   end
      #
      # @param interactors [Array<ActiveInteractor::Base>] the interactors to call
      def organize(*interactors)
        @organized = interactors.flatten
      end

      # An Array of declared Interactors to be invoked
      # @return [Array<ActiveInteractor::Base] the organized interactors
      def organized
        @organized ||= []
      end
    end

    # Invoke the organized interactors. An organizer is
    #  expected not to define its own {ActiveInteractor::Interactor#perform #perform} method
    #  in favor of this default implementation.
    def perform
      self.class.organized.each do |interactor|
        run_callbacks :each_perform do
          self.context = interactor.new(context)
                                   .tap(&:skip_clean_context!)
                                   .execute_perform!
        end
      end
    end
  end
end
