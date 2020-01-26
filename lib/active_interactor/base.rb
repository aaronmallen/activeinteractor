# frozen_string_literal: true

module ActiveInteractor
  # The base class all {Base interactors} should inherit from.
  #
  # When {Base} is loaded by your application an
  # {https://api.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html ActiveSupport load hook} is called
  # with `:active_interactor` and {Base}.
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.0
  #
  # @example a basic {Base interactor}
  #   class MyInteractor < ActiveInteractor::Base
  #     def perform
  #       # TODO: implement the perform method
  #     end
  #
  #     def rollback
  #       # TODO: implement the rollback method
  #     end
  #   end
  class Base
    extend ActiveInteractor::Interactor::Callbacks::ClassMethods
    extend ActiveInteractor::Interactor::Context::ClassMethods
    extend ActiveInteractor::Interactor::Perform::ClassMethods

    include ActiveSupport::Callbacks
    include ActiveInteractor::Interactor::Callbacks
    include ActiveInteractor::Interactor::Context
    include ActiveInteractor::Interactor::Perform
  end

  ActiveSupport.run_load_hooks(:active_interactor, Base)
end
