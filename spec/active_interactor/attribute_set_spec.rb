# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::AttributeSet do
  describe '#add' do
    subject(:add) { attribute_set.add(*attribute_options) }

    let(:name) { :test }
    let(:type) { String }
    let(:attribute_set) { described_class.new }

    context 'when attribute does not exist' do
      before do
        new_attribute
        allow(ActiveInteractor::Attribute).to receive(:new)
          .with(name: name, type: type, description: nil)
          .and_return(new_attribute)
      end

      let(:new_attribute) { create_attribute }
      let(:attribute_options) { [name, type] }

      it { is_expected.to be_a ActiveInteractor::Attribute }
      it { expect { add }.to change { attribute_set[name] }.from(nil).to(new_attribute) }
    end

    context 'when attribute exists' do
      before do
        attributes
        allow(ActiveInteractor::Attribute).to receive(:new)
          .with(name: name, type: type, description: nil)
          .and_return(attributes.last)
      end

      let(:attributes) { [create_attribute(name), create_attribute(name)] }
      let(:attribute_set) { described_class.new(attributes.first) }
      let(:attribute_options) { [name, type] }

      it { is_expected.to be_a ActiveInteractor::Attribute }
      it { expect { add }.to change { attribute_set[name] }.from(attributes.first).to(attributes.last) }
    end

    context 'when given attribute_options for Attribute#name, and Attribute#type' do
      let(:attribute_options) { [name, type] }

      it { is_expected.to have_attributes(name: name, type: type, description: nil) }
    end

    context 'when given options for Attribute#name, Attribute#type, and Attribute#description' do
      let(:description) { 'A test attribute' }
      let(:attribute_options) { [name, type, description] }

      it { is_expected.to have_attributes(name: name, type: type, description: description) }
    end

    context 'when given options for Attribute#name, Attribute#type, and an options hash' do
      let(:options) { { description: 'A test description', required: true, default_value: 'test' } }
      let(:attribute_options) { [name, type, options] }

      it { is_expected.to have_attributes(name: name, type: type, description: options[:description]) }
      it { is_expected.to have_attributes(required?: options[:required], default_value: options[:default_value]) }
    end

    context 'when given an options hash' do
      let(:options) do
        {
          name: name,
          type: type,
          description: 'A test description',
          required: true,
          default_value: 'test'
        }
      end
      let(:attribute_options) { [options] }

      it { is_expected.to have_attributes(name: name, type: type, description: options[:description]) }
      it { is_expected.to have_attributes(required?: options[:required], default_value: options[:default_value]) }
    end
  end

  describe '#attribute?' do
    subject(:attribute?) { attribute_set.attribute?(name) }

    let(:name) { :test }

    context 'when attribute exists' do
      let(:attribute) { create_attribute(name) }
      let(:attribute_set) { described_class.new(attribute) }

      it { is_expected.to eq true }
    end

    context 'when attribute does not exists' do
      let(:attribute_set) { described_class.new }

      it { is_expected.to eq false }
    end
  end

  describe '#attribute_names' do
    subject(:attribute_names) { attribute_set.attribute_names }

    let(:attribute) { create_attribute }
    let(:attribute_set) { described_class.new(attribute) }

    it { is_expected.to eq [attribute.name] }
  end

  describe '#clear!' do
    subject(:clear!) { attribute_set.clear! }

    let(:attribute_set) { described_class.new(create_attribute) }

    it { is_expected.to be_empty }
  end

  describe '#deep_dup' do
    subject(:deep_dup) { attribute_set.deep_dup }

    before { allow(attribute).to receive(:dup).and_return(dupped_attribute) }

    let(:attribute) { create_attribute }
    let(:dupped_attribute) { create_attribute }
    let(:attribute_set) { described_class.new(attribute) }

    it { is_expected.to be_an described_class }
    it { is_expected.not_to eq attribute_set }

    it 'is expected to dup Attributes' do
      expect(deep_dup[attribute.name]).to eq dupped_attribute
    end
  end

  describe '#empty?' do
    subject(:empty?) { attribute_set.empty? }

    context 'when AttributeSet has no attributes' do
      let(:attribute_set) { described_class.new }

      it { is_expected.to eq true }
    end

    context 'when AttributeSet has attributes' do
      let(:attribute_set) { described_class.new(create_attribute) }

      it { is_expected.to eq false }
    end
  end

  describe '#get_attribute' do
    subject(:get_attribute) { attribute_set.get_attribute(name) }

    let(:name) { :test }

    context 'when attribute exists' do
      let(:attribute) { create_attribute(name) }
      let(:attribute_set) { described_class.new(attribute) }

      it { is_expected.to eq attribute }
    end

    context 'when attribute does not exists' do
      let(:attribute_set) { described_class.new }

      it { is_expected.to be_nil }
    end
  end

  describe '#get_value' do
    subject(:get_value) { attribute_set.get_value(name) }

    let(:name) { :test }

    context 'when attribute exists' do
      let(:value) { 'test' }
      let(:attribute) { create_attribute_with_value(value, name: name) }
      let(:attribute_set) { described_class.new(attribute) }

      it { is_expected.to eq value }
    end

    context 'when attribute does not exists' do
      let(:attribute_set) { described_class.new }

      it { is_expected.to be_nil }
    end
  end

  describe '#to_hash' do
    subject(:to_hash) { attribute_set.to_hash }

    context 'when AttributeSet has initialized and uninitialized attributes' do
      let(:initialized_attribute) { create_attribute_with_value('value', name: :test1) }
      let(:uninitialized_attribute) { create_attribute(:test2) }
      let(:attribute_set) { described_class.new(initialized_attribute, uninitialized_attribute) }

      it { is_expected.to eq({ initialized_attribute.name => initialized_attribute.value }) }
    end
  end

  describe '#write_value' do
    subject(:write_value) { attribute_set.write_value(name, value) }

    let(:name) { :test }

    context 'when attribute exists and has no value' do
      let(:attribute_set) { described_class.new(create_attribute(name)) }
      let(:value) { 'test' }

      it { is_expected.to eq value }
      it { expect { write_value }.to change { attribute_set[name].value }.from(nil).to(value) }
    end

    context 'when attribute exists and has a value' do
      let(:old_value) { 'old value' }
      let(:attribute_set) { described_class.new(create_attribute_with_value(old_value, name: name)) }
      let(:value) { 'new value' }

      it { is_expected.to eq value }
      it { expect { write_value }.to change { attribute_set[name].value }.from(old_value).to(value) }
    end

    context 'when attribute does not exist' do
      let(:attribute_set) { described_class.new }
      let(:value) { 'test' }

      it { is_expected.to be_nil }
    end
  end

  def create_attribute(name = :test, options = {})
    attribute_options = { name: name, type: String }.merge(options)
    ActiveInteractor::Attribute.new(**attribute_options)
  end

  def create_attribute_with_value(value, options = {})
    attribute = create_attribute(options[:name], options)
    attribute.write_value(value)
    attribute
  end
end
