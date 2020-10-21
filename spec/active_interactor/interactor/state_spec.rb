# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor::State do
  describe '::FAILURE_STATUS' do
    subject { described_class::FAILURE_STATUS }

    it { is_expected.to eq :failed }
  end

  describe '::SUCCESS_STATUS' do
    subject { described_class::SUCCESS_STATUS }

    it { is_expected.to eq :success }
  end

  describe '#called' do
    subject { state.called }

    let(:state) { described_class.new }

    it { is_expected.to be_an Array }

    context 'when no interactors have been #called!' do
      it { is_expected.to be_empty }
    end

    context 'when an interactor has been #called!' do
      before { state.called!(interactor) }

      let(:interactor) { instance_double('ActiveInteractor::Base') }

      it 'is expected to include the interactor' do
        expect(state.called).to include interactor
      end
    end
  end

  describe '#called!' do
    subject(:called!) { state.called!(interactor) }

    let(:state) { described_class.new }
    let(:interactor) { instance_double('ActiveInteractor::Base') }

    it 'is expected to add the interactor to #called' do
      expect { called! }.to change(state.called, :count).by(1)
      expect(state.called).to include interactor
    end
  end

  describe '#fail!' do
    subject(:fail!) { state.fail! }

    let(:state) { described_class.new }

    it { expect { fail! }.to change(state, :status).to(described_class::FAILURE_STATUS) }
  end

  describe '#failure?' do
    subject { state.failure? }

    let(:state) { described_class.new }

    it { is_expected.to eq false }

    context 'when #fail! is called' do
      before { state.fail! }

      it { is_expected.to eq true }
    end
  end

  describe '#rolled_back' do
    subject { state.rolled_back }

    let(:state) { described_class.new }

    it { is_expected.to be_an Array }

    context 'when no interactors have been #rolled_back!' do
      it { is_expected.to be_empty }
    end

    context 'when an interactor has been #rolled_back!' do
      before { state.rolled_back!(interactor) }

      let(:interactor) { instance_double('ActiveInteractor::Base') }

      it 'is expected to include the interactor' do
        expect(state.rolled_back).to include interactor
      end
    end
  end

  describe '#rolled_back!' do
    subject(:rolled_back!) { state.rolled_back!(interactor) }

    let(:state) { described_class.new }
    let(:interactor) { instance_double('ActiveInteractor::Base') }

    it 'is expected to add the interactor to #called' do
      expect { rolled_back! }.to change(state.rolled_back, :count).by(1)
      expect(state.rolled_back).to include interactor
    end
  end

  describe '#status' do
    subject { state.status }

    let(:state) { described_class.new }

    it { is_expected.to eq described_class::SUCCESS_STATUS }

    context 'when #fail! is called' do
      before { state.fail! }

      it { is_expected.to eq described_class::FAILURE_STATUS }
    end
  end

  describe '#success?' do
    subject { state.success? }

    let(:state) { described_class.new }

    it { is_expected.to eq true }

    context 'when #fail! is called' do
      before { state.fail! }

      it { is_expected.to eq false }
    end
  end
end
