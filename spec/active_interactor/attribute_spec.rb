# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Attribute do
  describe '#initialized?' do
    subject(:initialized) { attribute.initialized? }

    context 'when the attribute has a default value' do
      let(:attribute) { described_class.new(name: :test, type: String, default_value: 'test') }

      it { is_expected.to eq true }
    end

    context 'when the attribute has an assigned value' do
      before { attribute.write_value('test') }

      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq true }
    end

    context 'when the attribute has no value and no default value' do
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq false }
    end
  end

  describe '#required?' do
    subject(:required) { attribute.required? }

    context 'when an attribute is required' do
      let(:attribute) { described_class.new(name: :test, type: String, required: true) }

      it { is_expected.to eq true }
    end

    context 'when an attribute is not required' do
      let(:attribute) { described_class.new(name: :test, type: String, required: false) }

      it { is_expected.to eq false }
    end

    context 'when an attribute does not specify required' do
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq false }
    end
  end

  describe '#type' do
    subject(:type) { attribute.type }

    context 'when type is "String"' do
      let(:attribute) { described_class.new(name: :test, type: 'String') }

      it { is_expected.to eq String }
    end

    context 'when type is String' do
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq String }
    end
  end

  describe '#value' do
    subject(:value) { attribute.value }

    context 'when the attribute has a default value and no assigned value' do
      let(:default_value) { 'default' }
      let(:attribute) { described_class.new(name: :test, type: String, default_value: default_value) }

      it { is_expected.to eq default_value }
    end

    context 'when the attribute has a default value and an assigned value' do
      before { attribute.write_value(assigned_value) }

      let(:assigned_value) { 'assigned' }
      let(:default_value) { 'default' }
      let(:attribute) { described_class.new(name: :test, type: String, default_value: default_value) }

      it { is_expected.to eq assigned_value }
    end

    context 'when the attribute has no default value and no assigned value' do
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to be_nil }
    end
  end

  describe '#write_value' do
    subject(:write_value) { attribute.write_value(value) }

    context 'when the attribute has a default value' do
      let(:value) { 'assigned' }
      let(:default_value) { 'default' }
      let(:attribute) { described_class.new(name: :test, type: String, default_value: default_value) }

      it { is_expected.to eq value }
      it { expect { write_value }.to change(attribute, :value).to(value) }
    end

    context 'when the attribute has no default value' do
      let(:value) { 'assigned' }
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq value }
      it { expect { write_value }.to change(attribute, :initialized?).to(true) }
      it { expect { write_value }.to change(attribute, :value).to(value) }
    end
  end
end
