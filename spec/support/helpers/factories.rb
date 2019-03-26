# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Spec
  module Helpers
    module Factories
      def build_interactor(class_name = 'TestInteractor', &block)
        Object.send(:remove_const, class_name.to_sym) if Object.const_defined?(class_name)
        interactor = Object.const_set(class_name, Class.new(ActiveInteractor::Base))
        interactor.class_eval(&block) if block
        interactor
      end
    end
  end
end
