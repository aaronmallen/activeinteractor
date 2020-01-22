# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # The base {Base organizer} class all {Base organizers} should inherit from.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    class Base < ActiveInteractor::Base
      extend ActiveInteractor::Organizer::Callbacks::ClassMethods
      extend ActiveInteractor::Organizer::Organize::ClassMethods
      extend ActiveInteractor::Organizer::Perform::ClassMethods

      include ActiveInteractor::Organizer::Callbacks
      include ActiveInteractor::Organizer::Perform
    end
  end
end
