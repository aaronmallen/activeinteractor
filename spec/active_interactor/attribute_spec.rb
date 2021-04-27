# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Attribute do
  describe '#initialized?' do
    subject(:initialized) { attribute.initialized? }

    context 'when the attribute has a default value' do
      let(:attribute) { described_class.new(name: :test, type: String, default_value: 'test') }

      it { is_expected.to eq true }
    end

    context 'when the attribute has a value' do
      before { attribute.write_value('test') }

      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq true }
    end

    context 'when the attribute has no value and no default value' do
      let(:attribute) { described_class.new(name: :test, type: String) }

      it { is_expected.to eq false }
    end
  end
end
