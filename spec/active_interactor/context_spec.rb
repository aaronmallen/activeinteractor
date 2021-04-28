# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context do
  after { described_class._default_attributes.clear! }

  describe '._default_attributes' do
    subject(:_default_attributes) { described_class._default_attributes }

    it { is_expected.to be_a ActiveInteractor::AttributeSet }
  end

  describe '.attribute' do
    subject(:attribute) { described_class.attribute(*attribute_options) }

    let(:attribute_name) { :test }
    let(:attribute_type) { String }
    let(:attribute_options) { [attribute_name, attribute_type] }

    it { is_expected.to be_a ActiveInteractor::Attribute }
    it { is_expected.to have_attributes(name: attribute_name, type: attribute_type) }
  end

  describe '.attribute?' do
    subject(:attribute) { described_class.attribute?(attribute_name) }

    let(:attribute_name) { :test_attribute }

    context 'when attribute exists' do
      before { described_class.attribute(attribute_name, String) }

      it { is_expected.to eq true }
    end

    context 'when attribute does not exists' do
      it { is_expected.to eq false }
    end
  end

  describe '.attribute_names' do
    subject(:attribute_names) { described_class.attribute_names }

    before { described_class.attribute(attribute_name, String) }

    let(:attribute_name) { :test_attribute }

    it { is_expected.to eq [attribute_name] }
  end

  describe '.new' do
    subject(:new_context) { described_class.new(attributes) }

    context 'when given known attributes' do
      before { described_class.attribute(attribute_name, String) }

      let(:attribute_name) { :test_attribute }
      let(:attributes) { { attribute_name => 'test' } }

      it { is_expected.to respond_to(attribute_name) }
      it { is_expected.to have_attributes(attributes) }
    end

    context 'when given unknown attributes' do
      let(:attribute_name) { :test_attribute }
      let(:attributes) { { attribute_name => 'test' } }

      it { is_expected.not_to respond_to(attribute_name) }
    end
  end

  describe '#[]' do
    subject(:fetch) { context_instance[attribute_name] }

    let(:attribute_name) { :test_attribute }

    context 'when attribute exists' do
      before { described_class.attribute(attribute_name, String) }

      let(:value) { 'test' }
      let(:context_instance) { described_class.new(attribute_name => value) }

      it { is_expected.to eq value }
    end

    context 'when attribute exists but has no value' do
      before { described_class.attribute(attribute_name, String) }

      let(:context_instance) { described_class.new }

      it { is_expected.to be_nil }
    end

    context 'when attribute does not exists' do
      let(:context_instance) { described_class.new }

      it { is_expected.to be_nil }
    end
  end

  describe '#[]=' do
    subject(:set) { context_instance[attribute_name] = value }

    let(:attribute_name) { :test_attribute }

    context 'when attribute exists but does not have a value' do
      before { described_class.attribute(attribute_name, String) }

      let(:value) { 'test' }
      let(:context_instance) { described_class.new }

      it { is_expected.to eq value }
      it { expect { set }.to change { context_instance[attribute_name] }.from(nil).to(value) }
    end

    context 'when attribute exists and has a value' do
      before { described_class.attribute(attribute_name, String) }

      let(:old_value) { 'old value' }
      let(:value) { 'new value' }
      let(:context_instance) { described_class.new(attribute_name => old_value) }

      it { is_expected.to eq value }
      it { expect { set }.to change { context_instance[attribute_name] }.from(old_value).to(value) }
    end

    context 'when attribute does not exist' do
      let(:value) { 'test' }
      let(:context_instance) { described_class.new }

      it { expect { set }.not_to change { context_instance[attribute_name] }.from(nil) }
    end
  end

  describe '#attributes' do
    subject(:attributes) { context_instance.attributes }

    context 'when attributes exist some having values and some not having values' do
      before do
        described_class.attribute(attribute_without_value_name, String)

        context_attributes.each do |attribute_name, _|
          described_class.attribute(attribute_name, String)
        end
      end

      let(:context_attributes) { { test_attribute: 'test' } }
      let(:context_instance) { described_class.new(context_attributes) }
      let(:attribute_without_value_name) { :no_value }

      it { is_expected.to be_a Hash }
      it { is_expected.to eq context_attributes }
      it { is_expected.not_to have_key(attribute_without_value_name) }
    end
  end

  describe '#attribute?' do
    subject(:attribute?) { described_class.new.attribute?(attribute_name) }

    let(:attribute_name) { :test_attribute }

    context 'when attribute exists' do
      before { described_class.attribute(attribute_name, String) }

      it { is_expected.to eq true }
    end

    context 'when attribute does not exist' do
      it { is_expected.to eq false }
    end
  end

  describe '#attribute_names' do
    subject(:attribute_names) { described_class.new.attribute_names }

    before { described_class.attribute(attribute_name, String) }

    let(:attribute_name) { :test_attribute }

    it { is_expected.to eq [attribute_name] }
  end

  describe 'attribute methods' do
    context 'when an attribute exists and has a value' do
      before { described_class.attribute(:test_attribute, String) }

      let(:context_instance) { described_class.new(test_attribute: 'test') }

      it { expect(context_instance).to respond_to(:test_attribute) }
      it { expect(context_instance).to respond_to(:test_attribute=) }
      it { expect(context_instance.test_attribute).to eq 'test' }
      it { expect { context_instance.test_attribute = 'a' }.to change(context_instance, :test_attribute).to('a') }
      it { expect { context_instance.send(:test_attribute=) }.to raise_error(ArgumentError) }
      it { expect { context_instance.unknown_attribute }.to raise_error(NoMethodError) }
    end
  end
end
