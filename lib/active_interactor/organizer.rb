# frozen_string_literal: true

module ActiveInteractor
  class Organizer
    include Interactor::Core

    class << self
      def organize(*interactors)
        @organized = interactors.flatten
      end

      def organized
        @organized ||= []
      end
    end

    def perform
      self.class.organized.each do |interactor|
        interactor.perform!(context)
      end
    end
  end
end
