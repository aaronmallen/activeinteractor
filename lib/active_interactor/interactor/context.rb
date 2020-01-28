# frozen_string_literal: true

module ActiveInteractor
  module Interactor
    # Interactor context methods. Because {Context} is a module classes should include {Context} rather than inherit
    # from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.0
    module Context
      # Interactor context class methods. Because {ClassMethods} is a module classes should extend {ClassMethods}
      # rather than inherit from it.
      #
      # @author Aaron Allen <hello@aaronmallen.me>
      # @since 0.1.0
      module ClassMethods
        # @!method context_attributes(*attributes)
        #  Call {ActiveInteractor::Context::Attributes#attributes .attributes} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        #  @example
        #    class MyInteractor < ActiveInteractor::Base
        #      context_attributes :first_name, :last_name
        #    end
        #
        #    MyInteractor.context_class.attributes
        #    #=> [:first_name, :last_name]
        #
        # @example Setting default values on the {ActiveInteractor::Context::Base context} class
        #    class MyInteractor < ActiveInteractor::Base
        #      context_attribute :first_name, default: -> { 'Aaron' }
        #    end
        #
        #    MyInteractor.perform
        #    #=> <#MyInteractor::Context first_name='Aaron'>
        #
        #   MyInteractor.perform(first_name: 'Bob')
        #   #=> <#MyInteractor::Context first_name='Bob'>
        #
        # @!method context_attribute_missing(match, *args, &block)
        #  Call {ActiveInteractor::Context::Base.attribute_missing .attribute_missing} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since unreleased
        #
        # @!method context_respond_to_without_attributes?(method, include_private_methods = false)
        #  Call {ActiveInteractor::Context::Base.respond_to_without_attributes? .respond_to_without_attributes?} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since unreleased
        delegate :attributes, :attribute_missing, :respond_to_without_attributes?, to: :context_class, prefix: :context

        # @!method context_attribute(name, type=Type::Value.new, **options)
        #  Call {ActiveInteractor::Context::Base.attribute .attribute} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since unreleased
        #
        # @!method context_attribute_names
        #  Call {ActiveInteractor::Context::Base.attribute_names .attribute_names} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since unreleased
        delegate(*ActiveModel::Attributes::ClassMethods.instance_methods, to: :context_class, prefix: :context)

        # @!method context_attribute_method?(attribute)
        #  Call {ActiveInteractor::Context::Base.attribute_method? .attribute_method?} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_clear_validators!(attribute)
        #  Call {ActiveInteractor::Context::Base.clear_validators! .clear_validators!} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validate(*args, &block)
        #  Call {ActiveInteractor::Context::Base.validate .validate} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates(*attributes)
        #  Call {ActiveInteractor::Context::Base.validates .validates} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates!(*attributes)
        #  Call {ActiveInteractor::Context::Base.validates! .validates!} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_each(*attr_names, &block)
        #  Call {ActiveInteractor::Context::Base.validates_each .validates_each} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_with(*args, &block)
        #  Call {ActiveInteractor::Context::Base.validates_with .validates_with} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validators
        #  Call {ActiveInteractor::Context::Base.validators .validators} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validators_on(*attributes)
        #  Call {ActiveInteractor::Context::Base.validators_on .validators_on} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        delegate(*ActiveModel::Validations::ClassMethods.instance_methods, to: :context_class, prefix: :context)

        # @!method context_validates_absence_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_absence_of .validates_absence_of} on the {Base interactor}
        #  class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_acceptance_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_acceptance_of .validates_acceptance_of} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_confirmation_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_confirmation_of .validates_confirmation_of} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_exclusion_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_exclusion_of .validates_exclusion_of} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_format_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_format_of .validates_format_of} on the {Base interactor}
        #  class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_inclusion_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_inclusion_of .validates_inclusion_of} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_length_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_length_of .validates_length_of} on the {Base interactor}
        #  class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_numericality_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_numericality_of .validates_numericality_of} on the
        #  {Base interactor} class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_presence_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_presence_of .validates_presence_of} on the {Base interactor}
        #  class' {#context_class context class}
        #
        #  @since 0.1.0
        #
        # @!method context_validates_size_of(*attr_names)
        #  Call {ActiveInteractor::Context::Base.validates_size_of .validates_size_of} on the {Base interactor} class'
        #  {#context_class context class}
        #
        #  @since 0.1.0
        delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context_class, prefix: :context)

        # Get the {Base interactor} class' {ActiveInteractor::Context::Base context} class. If no class is found or no
        # class is set via the {#contextualize_with} method a new class is created.
        #
        # @see ActiveInteractor::Context::Loader.find_or_create
        #
        # @return [Const] the {Base interactor} class' {ActiveInteractor::Context::Base context} class
        def context_class
          @context_class ||= ActiveInteractor::Context::Loader.find_or_create(self)
        end

        # Set the {Base interactor} class' {#context_class context class}
        #
        # @since 1.0.0
        #
        # @example
        #   class User < ActiveRecord::Base
        #   end
        #
        #   class MyInteractor < ActiveInteractor::Base
        #     contextualize_with :user
        #   end
        #
        #   MyInteractor.context_class
        #   #=> User
        #
        # @param klass [Const, Symbol, String] the class to use as context
        # @raise [Error::InvalidContextClass] if the class can not be found.
        # @return [Const] the {Base interactor} class' {ActiveInteractor::Context::Base context} class
        def contextualize_with(klass)
          @context_class = begin
            context_class = klass.to_s.classify.safe_constantize
            raise(ActiveInteractor::Error::InvalidContextClass, klass) unless context_class

            context_class
          end
        end
      end

      # @!method context_attribute_missing(match, *args, &block)
      #  Call {ActiveInteractor::Context::Base#attribute_missing #attribute_missing} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since unreleased
      #
      # @!method context_attribute_names
      #  Call {ActiveInteractor::Context::Base#attribute_names #attribute_names} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since unreleased
      #
      # @!method context_fail!(errors = nil)
      #  Call {ActiveInteractor::Context::Status#fail! #fail!} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 1.0.0
      #
      # @!method context_respond_to_without_attributes?(method, include_private_methods = false)
      #  Call {ActiveInteractor::Context::Base#respond_to_without_attributes? #respond_to_without_attributes?} on the
      #  {Base interactor} instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since unreleased
      #
      # @!method context_rollback!
      #  Call {ActiveInteractor::Context::Status#rollback! #rollback!} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 1.0.0
      delegate :attribute_missing, :attribute_names, :fail!, :respond_to_without_attributes?, :rollback!,
               to: :context, prefix: true

      # @!method context_errors
      #  Call {ActiveInteractor::Context::Base#errors #errors} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_invalid?(context = nil)
      #  Call {ActiveInteractor::Context::Base#invalid? #invalid?} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_valid?(context = nil)
      #  Call {ActiveInteractor::Context::Base#valid? #valid?} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validate(context = nil)
      #  Call {ActiveInteractor::Context::Base#validate #validate} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validate!(context = nil)
      #  Call {ActiveInteractor::Context::Base#validate! #validate!} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_with(*args, &block)
      #  Call {ActiveInteractor::Context::Base#validates_with #validates_with} on the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      delegate(*ActiveModel::Validations.instance_methods, to: :context, prefix: true)

      # @!method context_validates_absence_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_absence_of #validates_absence_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_acceptance_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_acceptance_of #validates_acceptance_of} on the
      #  {Base interactor} instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_confirmation_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_confirmation_of #validates_confirmation_of} on the
      #  {Base interactor} instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_exclusion_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_exclusion_of #validates_exclusion_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_format_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_format_of #validates_format_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_inclusion_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_inclusion_of #validates_inclusion_of}  on the
      #  {Base interactor} instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_length_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_length_of #validates_length_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_numericality_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_numericality_of #validates_numericality_of} on the
      #  {Base interactor} instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_presence_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_presence_of #validates_presence_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      #
      # @!method context_validates_size_of(*attr_names)
      #  Call {ActiveInteractor::Context::Base#validates_size_of #validates_size_of} on the {Base interactor}
      #  instance's {ActiveInteractor::Context::Base context} instance
      #
      #  @since 0.1.0
      delegate(*ActiveModel::Validations::HelperMethods.instance_methods, to: :context, prefix: true)

      # Initialize a new instance of {Base}
      #
      # @param context [Hash, Class] attributes to assign to the {Base interactor} instance's
      #  {ActiveInteractor::Context::Base context} instance
      # @return [Base] a new instance of {Base}
      def initialize(context = {})
        @context = self.class.context_class.new(context)
      end

      # Mark the {Base interactor} instance as called on the instance's {ActiveInteractor::Context::Base context}
      # instance and return the {ActiveInteractor::Context::Base context} instance.
      #
      # @since 1.0.0
      #
      # @return [Class] the {ActiveInteractor::Context::Base context} instance
      def finalize_context!
        context.called!(self)
        context
      end

      private

      attr_accessor :context
    end
  end
end
