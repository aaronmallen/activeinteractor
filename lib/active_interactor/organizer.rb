# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

module ActiveInteractor
  # A base Organizer class.  All organizers should inherit from
  #  {Organizer}.
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @!attribute [r] organized
  #  @!scope class
  #  @return [Array<Base>] the organized interactors
  # @example a basic organizer
  #  class MyInteractor1 < ActiveInteractor::Base
  #    def perform
  #      context.interactor1 = true
  #    end
  #  end
  #
  #  class MyInteractor2 < ActiveInteractor::Base
  #    def perform
  #      context.interactor2 = true
  #    end
  #  end
  #
  #  class MyOrganizer < ActiveInteractor::Organizer
  #    organize MyInteractor1, MyInteractor2
  #  end
  #
  #  MyOrganizer.perform
  #  #=> <MyOrganizer::Context interactor1=true interactor2=true>
  class Organizer < Base
    class_attribute :organized, instance_writer: false, default: []
    define_callbacks :each_perform

    # Define a callback to call after each organized interactor's
    #  {Base.perform} has been invoked
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
    def self.after_each_perform(*filters, &block)
      set_callback(:each_perform, :after, *filters, &block)
    end

    # Define a callback to call around each organized interactor's
    #  {Base.perform} has been invokation
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
    def self.around_each_perform(*filters, &block)
      set_callback(:each_perform, :around, *filters, &block)
    end

    # Define a callback to call before each organized interactor's
    #  {Base.perform} has been invoked
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
    def self.before_each_perform(*filters, &block)
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
    # @param interactors [Array<Base>] the interactors to call
    def self.organize(*interactors)
      self.organized = interactors.flatten.map do |interactor|
        interactor.to_s.classify.safe_constantize
      end.compact
    end

    # Invoke the organized interactors. An organizer is
    #  expected not to define its own {Base#perform} method
    #  in favor of this default implementation.
    def perform
      self.class.organized.each do |interactor|
        self.context = execute_interactor_perform_with_callbacks!(interactor)
      end
    rescue Error::ContextFailure => e
      self.context = e.context
    ensure
      self.context = self.class.context_class.new(context)
    end

    private

    def execute_interactor_perform_with_callbacks!(interactor)
      run_callbacks :each_perform do
        interactor.new(context).execute_perform!
      end
    end
  end
end
