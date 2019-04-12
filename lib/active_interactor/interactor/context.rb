# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Provides ActiveInteractor::Interactor::Context methods to included classes
    #
    # @api private
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.0.1
    # @version 0.2
    module Context
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        include Callbacks

        delegate(*ActiveModel::Validations.instance_methods, to: :context, prefix: true)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context, prefix: true)
      end

      module ClassMethods
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :context_class, prefix: :context)
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context_class, prefix: :context)

        # Create the context class for inherited classes.
        def inherited(base)
          base.const_set 'Context', Class.new(ActiveInteractor::Context::Base)
        end

        # Assign attributes to the context class of the interactor
        #
        # @example Assign attributes to the context class
        #  class MyInteractor > ActiveInteractor::Base
        #    context_attributes :first_name, :last_name
        #  end
        #
        #  MyInteractor::Context.attributes
        #  #=> [:first_name, :last_name]
        # @param attributes [Array] the attributes to assign to the context
        def context_attributes(*attributes)
          context_class.attributes = attributes
        end

        # Assign attribute aliases to the context class of the interactor
        #  any aliases passed to the context will be assigned to the
        #  key of the aliases hash
        #
        # @example Assign attribute aliases to the context class
        #  class MyInteractor > ActiveInteractor::Base
        #   context_attributes :first_name, :last_name
        #   context_attribute_aliases last_name: :sir_name
        #  end
        #
        #  MyInteractor::Context.attribute_aliases
        #  #=> { last_name: [:sir_name] }
        #
        #  class MyInteractor > ActiveInteractor::Base
        #   context_attributes :first_name, :last_name
        #   context_attribute_aliases last_name: %i[sir_name, sirname]
        #  end
        #
        #  MyInteractor::Context.attribute_aliases
        #  #=> { last_name: [:sir_name, :sirname] }
        #
        #  context = MyInteractor.perform(first_name: 'Aaron', sir_name: 'Allen')
        #  #=> <#MyInteractor::Context first_name='Aaron', last_name='Allen')
        #
        #  context.sir_name
        #  #=> nil
        #
        #  context.last_name
        #  #=> 'Allen'
        #
        # @param aliases [Hash{Symbol => Symbol, Array<Symbol>}] the attribute aliases
        #
        # @return [Hash{Symbol => Array<Symbol>}] the attribute aliases
        def context_attribute_aliases(aliases = {})
          context_class.alias_attributes(aliases)
        end

        # The context class of the interactor
        #
        # @example
        #  class MyInteractor < ActiveInteractor::Base
        #  end
        #
        #  MyInteractor.context_class
        #  #=> MyInteractor::Context
        def context_class
          const_get 'Context'
        end
      end
    end
  end
end
