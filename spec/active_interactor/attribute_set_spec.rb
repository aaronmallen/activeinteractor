# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::AttributeSet do
  describe '#[]' do
    subject(:fetch_attribute) { attribute_set[attribute_name] }

    context 'when attribute exists' do
      let(:attributes) { { test: instance_double('ActiveInteractor::Attribute') } }
      let(:attribute_set) { described_class.new(attributes) }
      let(:attribute_name) { :test }

      it 'is expected to return the attribute' do
        expect(fetch_attribute).to eq attributes[attribute_name]
      end
    end

    context 'when attribute does not exist' do
      let(:attribute_set) { described_class.new({}) }
      let(:attribute_name) { :test }

      it { is_expected.to be_nil }
    end
  end

  describe '#[]=' do
    subject(:set_attribute) { attribute_set[attribute_name] = value }

    context 'when attribute already exists' do
      let(:attributes) { { test: instance_double('ActiveInteractor::Attribute', value: 'test') } }
      let(:attribute_set) { described_class.new(attributes) }
      let(:attribute_name) { :test }
      let(:value) { instance_double('ActiveInteractor::Attribute', value: 'new_test') }

      it 'is expected to override the existing value' do
        set_attribute

        expect(attribute_set[attribute_name]).to eq value
      end
    end

    context 'when attribute does not exist' do
      let(:attribute_set) { described_class.new({}) }
      let(:attribute_name) { :test }
      let(:value) { instance_double('ActiveInteractor::Attribute') }

      it 'is expected to set the new value' do
        set_attribute

        expect(attribute_set[attribute_name]).to eq value
      end
    end
  end

  describe '#deep_dup' do
    subject(:deep_dup) { attribute_set.deep_dup }

    context 'when AttributeSet has attributes' do
      let(:attributes) { { test: instance_double('ActiveInteractor::Attribute') } }
      let(:attribute_set) { described_class.new(attributes) }

      it { is_expected.not_to eq attribute_set }
      it { is_expected.to be_a described_class }

      it 'is expected to dup each attribute' do
        attributes.each { |name, attribute| allow(attribute).to receive(:dup) }
        deep_dup

        attributes.each { |name, attribute| expect(attribute).to have_received(:dup) }
      end
    end
  end

  describe '#fetch_value' do
    subject(:fetch_value) { attribute_set.fetch_value(attribute_name) }

    context 'when attribute exists' do
      let(:value) { 'test' }
      let(:attributes) { { test: instance_double('ActiveInteractor::Attribute', value: value) } }
      let(:attribute_set) { described_class.new(attributes) }
      let(:attribute_name) { :test }

      it 'is expected to return the attribute value' do
        expect(fetch_value).to eq value
      end
    end

    context 'when attribute does not exist' do
      let(:attribute_set) { described_class.new({}) }
      let(:attribute_name) { :test }

      it { is_expected.to be_nil }
    end
  end

  describe '#to_hash' do
    subject(:to_hash) { attribute_set.to_hash }

    context 'when AttributeSet has initialized and uninitialized attributes' do
      let(:initialized_attribute) { instance_double('ActiveInteractor::Attribute', value: 'test', initialized?: true) }
      let(:uninitialized_attribute) { instance_double('ActiveInteractor::Attribute', initialized?: false) }
      let(:attribute_set) { described_class.new(a: initialized_attribute, b: uninitialized_attribute) }

      it { is_expected.to be_a Hash }

      it 'is expected to return the appropriate hash' do
        expect(to_hash).to eq({a: initialized_attribute.value })
      end
    end
  end

  describe '#write_value' do
    subject(:write_value) { attribute_set.write_value(attribute_name, value) }

    context 'when attribute exists' do
      let(:attribute) { instance_double('ActiveInteractor::Attribute') }
      let(:attribute_name) { :test }
      let(:attribute_set) { described_class.new(attribute_name => attribute) }
      let(:value) { 'test' }

      it 'is expected to write the attribute value' do
        allow(attribute).to receive(:write_value)
        write_value

        expect(attribute).to have_received(:write_value).with(value)
      end
    end

    context 'when attribute does not exists' do
      let(:attribute_name) { :test }
      let(:attribute_set) { described_class.new({}) }
      let(:value) { 'test' }

      it 'is expected not to write an attribute value' do
        write_value

        expect(attribute_set[attribute_name]).to be_nil
      end
    end
  end
end
