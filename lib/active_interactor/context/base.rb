# frozen_string_literal: true

module ActiveInteractor
  module Context
    # The base {Base context} class all {Base context} objects should inherit from.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since 0.1.0
    #
    # @!method attribute(name, type=Type::Value.new, **options)
    #  @!scope class
    #  @since unreleased
    #
    #  @example Setting default values on the {Base context} class
    #    class MyContext < ActiveInteractor::Context::Base
    #      attribute :first_name, default: -> { 'Aaron' }
    #    end
    #
    #    MyContext.new
    #    #=> <#MyContext first_name='Aaron'>
    #
    #    MyContext.new(first_name: 'Bob')
    #    #=> <#MyContext first_name='Bob'>
    #
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Attributes/ClassMethods.html#method-i-attribute
    #   ActiveModel::Attributes::ClassMethods#attribute
    #
    #
    # @!method attribute_method?(attribute)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-attribute_method-3F
    #   ActiveModel::Validations::ClassMethods#attribute_method?
    #
    # @!method attribute_missing(match, *args, &block)
    #  @!scope class
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-attribute_missing
    #   ActiveModel::AttributeMethods#attribute_missing
    #
    # @!method attribute_names
    #  @!scope class
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Attributes/ClassMethods.html#method-i-attribute_names
    #   ActiveModel::Attributes::ClassMethods#attribute_names
    #
    # @!method clear_validators!(attribute)
    #  @!scope class
    #  @since 0.1.0
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-clear_validators-21
    #   ActiveModel::Validations::ClassMethods#clear_validators!
    #
    # @!method method_missing(method, *args, &block)
    #  @scope class
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-method_missing
    #   ActiveModel::AttributeMethods#method_missing
    #
    # @!method respond_to?(method, include_private_methods = false)
    #  @scope class
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to-3F
    #   ActiveModel::AttributeMethods#respond_to?
    #
    # @!method respond_to_without_attributes?(method, include_private_methods = false)
    #  @scope class
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to_without_attributes-3F
    #   ActiveModel::AttributeMethods#respond_to_without_attributes?
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
    # @!method attribute_missing(match, *args, &block)
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-attribute_missing
    #   ActiveModel::AttributeMethods#attribute_missing
    #
    # @!method attribute_names
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/Attributes/ClassMethods.html#method-i-attribute_names
    #   ActiveModel::Attributes::ClassMethods#attribute_names
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
    # @!method method_missing(method, *args, &block)
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-method_missing
    #   ActiveModel::AttributeMethods#method_missing
    #
    # @!method respond_to?(method, include_private_methods = false)
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to-3F
    #   ActiveModel::AttributeMethods#respond_to?
    #
    # @!method respond_to_without_attributes?(method, include_private_methods = false)
    #  @since unreleased
    #  @see
    #   https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to_without_attributes-3F
    #   ActiveModel::AttributeMethods#respond_to_without_attributes?
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
