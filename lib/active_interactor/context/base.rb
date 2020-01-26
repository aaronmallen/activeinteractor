# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base {Base context} class all {Base context} objects should inherit from.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.0
    #
    # @!method attribute_method?(attribute)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-attribute_method-3F
    #   ActiveModel::Validations::ClassMethods#attribute_method?
    #
    # @!method clear_validators!(attribute)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-clear_validators-21
    #   ActiveModel::Validations::ClassMethods#clear_validators!
    #
    # @!method validate(*args, &block)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validate
    #   ActiveModel::Validations::ClassMethods#validate
    #
    # @!method validates(*attributes)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
    #   ActiveModel::Validations::ClassMethods#validates
    #
    # @!method validates!(*attributes)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates-21
    #   ActiveModel::Validations::ClassMethods#validates!
    #
    # @!method validates_absence_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_absence_of
    #   ActiveModel::Validations::HelperMethods#validates_absence_of
    #
    # @!method validates_acceptance_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_acceptance_of
    #   ActiveModel::Validations::HelperMethods#validates_acceptance_of
    #
    # @!method validates_confirmation_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of
    #   ActiveModel::Validations::HelperMethods#validates_confirmation_of
    #
    # @!method validates_each(*attr_names, &block)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates_each
    #   ActiveModel::Validations::ClassMethods#validates_each
    #
    # @!method validates_exclusion_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_exclusion_of
    #   ActiveModel::Validations::HelperMethods#validates_exclusion_of
    #
    # @!method validates_format_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_format_of
    #   ActiveModel::Validations::HelperMethods#validates_format_of
    #
    # @!method validates_inclusion_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_inclusion_of
    #   ActiveModel::Validations::HelperMethods#validates_inclusion_of
    #
    # @!method validates_length_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_length_of
    #   ActiveModel::Validations::HelperMethods#validates_length_of
    #
    # @!method validates_numericality_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_numericality_of
    #   ActiveModel::Validations::HelperMethods#validates_numericality_of
    #
    # @!method validates_presence_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_presence_of
    #   ActiveModel::Validations::HelperMethods#validates_presence_of
    #
    # @!method validates_size_of(*attr_names)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_size_of
    #   ActiveModel::Validations::HelperMethods#validates_size_of
    #
    # @!method validates_with(*args, &block)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates_with
    #   ActiveModel::Validations::ClassMethods#validates_with
    #
    # @!method validators
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validators
    #   ActiveModel::Validations::ClassMethods#validators
    #
    # @!method validators_on(*attributes)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validators_on
    #   ActiveModel::Validations::ClassMethods#validators_on
    #
    # @!method errors
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-errors
    #   ActiveModel::Validations#errors
    #
    # @!method invalid?(context = nil)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-invalid-3F
    #   ActiveModel::Validations#invalid?
    #
    # @!method valid?(context = nil)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F
    #   ActiveModel::Validations#valid?
    #
    # @!method validate(context = nil)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate
    #   ActiveModel::Validations#validate
    #
    # @!method validate!(context = nil)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate-21
    #   ActiveModel::Validations#validate!
    #
    # @!method validates_absence_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_absence_of
    #   ActiveModel::Validations::HelperMethods#validates_absence_of
    #
    # @!method validates_acceptance_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_acceptance_of
    #   ActiveModel::Validations::HelperMethods#validates_acceptance_of
    #
    # @!method validates_confirmation_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of
    #   ActiveModel::Validations::HelperMethods#validates_confirmation_of
    #
    # @!method validates_exclusion_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_exclusion_of
    #   ActiveModel::Validations::HelperMethods#validates_exclusion_of
    #
    # @!method validates_format_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_format_of
    #   ActiveModel::Validations::HelperMethods#validates_format_of
    #
    # @!method validates_inclusion_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_inclusion_of
    #   ActiveModel::Validations::HelperMethods#validates_inclusion_of
    #
    # @!method validates_length_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_length_of
    #   ActiveModel::Validations::HelperMethods#validates_length_of
    #
    # @!method validates_numericality_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_numericality_of
    #   ActiveModel::Validations::HelperMethods#validates_numericality_of
    #
    # @!method validates_presence_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_presence_of
    #   ActiveModel::Validations::HelperMethods#validates_presence_of
    #
    # @!method validates_size_of(*attr_names)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_size_of
    #   ActiveModel::Validations::HelperMethods#validates_size_of
    #
    # @!method validates_with(*args, &block)
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validates_with
    #   ActiveModel::Validations#validates_with
    class Base < OpenStruct
      extend ActiveInteractor::Context::Attributes::ClassMethods

      include ActiveModel::Attributes
      include ActiveModel::Validations
      include ActiveInteractor::Context::Attributes
      include ActiveInteractor::Context::Status
    end
  end
end
