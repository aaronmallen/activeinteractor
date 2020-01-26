# frozen_string_literal: true

module ActiveInteractor
  module Organizer
    # Organizer organize methods. Because {Organize} is a module classes should include {Organize} rather than inherit
    # from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 1.0.0
    module Organize
      # Organizer organize class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 1.0.0
      module ClassMethods
        # {#organized Organize} {ActiveInteractor::Base interactors} to be called by the {Base organizer}.
        # A block will be evaluated on the {#organized InteractorInterfaceCollection} if a block is given.
        #
        # @since 0.1.0
        #
        # @example Basic organization of {ActiveInteractor::Base interactors}
        #   class MyInteractor1 < ActiveInteractor::Base; end
        #   class MyInteractor2 < ActiveInteractor::Base; end
        #   class MyOrganizer < ActiveInteractor::Organizer::Base
        #     organize :my_interactor_1, :my_interactor_2
        #   end
        #
        # @example Conditional organization of {ActiveInteractor::Base interactors}
        #   class MyInteractor1 < ActiveInteractor::Base; end
        #   class MyInteractor2 < ActiveInteractor::Base; end
        #   class MyOrganizer < ActiveInteractor::Organizer::Base
        #     organize do
        #       add :my_interactor_1
        #       add :my_interactor_2, if: -> { context.valid? }
        #     end
        #   end
        #
        # @example organization of {ActiveInteractor::Base interactors} with {Interactor::Perform::Options options}
        #   class MyInteractor1 < ActiveInteractor::Base; end
        #   class MyInteractor2 < ActiveInteractor::Base; end
        #   class MyOrganizer < ActiveInteractor::Organizer::Base
        #     organize do
        #       add :my_interactor_1, validate: false
        #       add :my_interactor_2, skip_perform_callbacks: true
        #     end
        #   end
        #
        # @param interactors [Array<Const, Symbol, String>, nil] the {ActiveInteractor::Base} interactor classes to be
        #  {#organized organized}
        # @return [InteractorInterfaceCollection] the {#organized} {ActiveInteractor::Base interactors}
        def organize(*interactors, &block)
          organized.concat(interactors) if interactors
          organized.instance_eval(&block) if block
          organized
        end

        # An organized collection of {ActiveInteractor::Base interactors}
        #
        # @return [InteractorInterfaceCollection] an instance of {InteractorInterfaceCollection}
        def organized
          @organized ||= ActiveInteractor::Organizer::InteractorInterfaceCollection.new
        end
      end
    end
  end
end
