# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'

require 'active_interactor/organizer/interactor_interface_collection'

module ActiveInteractor
  # A base Organizer class.  All organizers should inherit from
  #  {Organizer}.
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @!attribute [r] parallel
  #  @since 1.0.0
  #  @!scope class
  #  @return [Boolean] whether or not to run the interactors
  #    in parallel
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
    class_attribute :parallel, instance_writer: false, default: false
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
    # @example Basic interactor organization
    #   class MyOrganizer < ActiveInteractor::Organizer
    #     organize :interactor_one, :interactor_two
    #   end
    # @example Conditional interactor organization with block
    #   class MyOrganizer < ActiveInteractor::Organizer
    #     organize do
    #       add :interactor_one
    #       add :interactor_two, if: -> { context.valid? }
    #     end
    #   end
    # @example Conditional interactor organization with method
    #   class MyOrganizer < ActiveInteractor::Organizer
    #     organize do
    #       add :interactor_one
    #       add :interactor_two, unless: :invalid_context?
    #     end
    #
    #     private
    #
    #     def invalid_context?
    #       !context.valid?
    #     end
    #   end
    # @example Interactor organization with perform options
    #   class MyOrganizer < ActiveInteractor::Organizer
    #     organize do
    #       add :interactor_one, validate: false
    #       add :interactor_two, skip_perform_callbacks: true
    #     end
    #   end
    # @param interactors [Array<Base|Symbol|String>] the interactors to call
    # @yield [.organized] if block given
    # @return [InteractorInterfaceCollection] an instance of {InteractorInterfaceCollection}
    def self.organize(*interactors, &block)
      organized.concat(interactors) if interactors
      organized.instance_eval(&block) if block
      organized
    end

    # Organized interactors
    # @return [InteractorInterfaceCollection] an instance of {InteractorInterfaceCollection}
    def self.organized
      @organized ||= InteractorInterfaceCollection.new
    end

    # Run organized interactors in parallel
    # @since 1.0.0
    def self.perform_in_parallel
      self.parallel = true
    end

    # Invoke the organized interactors. An organizer is
    #  expected not to define its own {Interactor#perform #perform} method
    #  in favor of this default implementation.
    def perform
      if self.class.parallel
        perform_in_parallel
      else
        perform_in_order
      end
    end

    private

    def execute_interactor(interface, fail_on_error = false, perform_options = {})
      interface.perform(self, context, fail_on_error, perform_options)
    end

    def execute_interactor_with_callbacks(interface, fail_on_error = false, perform_options = {})
      args = [interface, fail_on_error, perform_options]
      return execute_interactor(*args) if options.skip_each_perform_callbacks

      run_callbacks :each_perform do
        execute_interactor(*args)
      end
    end

    def merge_contexts(contexts)
      contexts.each { |context| @context.merge!(context) }
      context_fail! if contexts.any?(&:failure?)
    end

    def perform_in_order
      self.class.organized.each do |interface|
        result = execute_interactor_with_callbacks(interface, true)
        context.merge!(result) if result
      end
    rescue Error::ContextFailure => e
      context.merge!(e.context)
    end

    def perform_in_parallel
      results = self.class.organized.map do |interface|
        Thread.new { execute_interactor_with_callbacks(interface, false, skip_rollback: true) }
      end
      merge_contexts(results.map(&:value))
    end
  end
end
