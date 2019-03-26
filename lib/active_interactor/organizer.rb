# frozen_string_literal: true

module ActiveInteractor
  # The Base Interactor class inherited by all Interactor::Organizers
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @version 0.1
  class Organizer < ActiveInteractor::Base
    class << self
      # Declare Interactors to be invoked as part of the
      #  organizer's invocation. These interactors are invoked in
      #  the order in which they are declared.
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

      # An Array of declared Interactors to be invoked.
      # @private
      def organized
        @organized ||= []
      end
    end

    # Invoke the organized interactors. An organizer is
    #  expected not to define its own {ActiveInteractor::Base#perform #perform} method
    #  in favor of this default implementation.
    def perform
      self.class.organized.each do |interactor|
        interactor.new(context)
                  .tap(&:skip_clean_context!)
                  .tap(&:call_perform!)
                  .context
      end
    end
  end
end
