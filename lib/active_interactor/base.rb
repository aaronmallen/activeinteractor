# frozen_string_literal: true

require 'active_interactor/interactor'

module ActiveInteractor
  # The base interactor class. All interactors should inherit from
  #  {Base}.
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.0.1
  # @example a basic interactor
  #  class MyInteractor < ActiveInteractor::Base
  #    def perform
  #      context.called = true
  #    end
  #  end
  #
  #  MyInteractor.perform
  #  #=> <MyInteractor::Context called=true>
  class Base
    include Interactor

    # Duplicates an instance of {Base}
    # @since 1.0.0-alpha.1
    # @return [Base] a new instance of {Base}
    def dup
      self.class.new(context.dup)
    end
  end
end
