# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::State::Manager do
  describe '#called!' do
    let(:state) { described_class.new }
    subject { state.called!(interactor) }

    context 'with an object that responds to #rollback' do
      let(:interactor) { build_interactor.new }

      it 'is expected to return the instance of state' do
        expect(subject).to eq state
      end

      it 'is expected to add the object to @_called' do
        expect { subject }.to change { state.send(:_called).count }.by(1)
        expect(subject.send(:_called)).to include interactor
      end
    end

    context 'with an object that does not respond to #rollback' do
      let(:interactor) { 'foo' }

      it 'is expected to return the instance of state' do
        expect(subject).to eq state
      end

      it 'is expected not to add the object to @_called' do
        expect { subject }.not_to(change { state.send(:_called).count })
        expect(subject.send(:_called)).not_to include interactor
      end
    end
  end

  describe '#fail!' do
    subject { described_class.new.fail!(errors) }

    context 'when no errors are provided' do
      let(:errors) { nil }
      it { is_expected.to be_failure }
    end

    context 'when a string is provided' do
      let(:errors) { 'test' }

      it { is_expected.to be_failure }
      it 'is expected to have errors on :interactor' do
        expect(subject.errors[:interactor]).not_to be_nil
        expect(subject.errors[:interactor]).to include errors
      end
    end

    context 'when an instance of ActiveModel::Errors is provided' do
      let(:errors) { ActiveModel::Errors.new(build_class('Model').new) }
      before { errors.add(:test, 'test') }

      it { is_expected.to be_failure }
      it 'is expected to merge! errors' do
        expect(subject.errors[:test]).not_to be_nil
        expect(subject.errors[:test]).to include 'test'
      end
    end
  end

  describe '#failure?' do
    subject { instance.failure? }
    let(:instance) { described_class.new }

    it { is_expected.to eq false }

    context 'after #fail! is called' do
      before { instance.fail! }

      it { is_expected.to eq true }
    end
  end

  describe '#rollback!' do
    subject { instance.rollback! }
    let(:instance) { described_class.new }

    context 'with called interactors' do
      let(:interactor1) { double(rollback: true) }
      let(:interactor2) { double(rollback: true) }

      before do
        [interactor1, interactor2].each { |interactor| instance.called!(interactor) }
      end

      it 'is expected to call rollback on called interactors' do
        subject
        expect(interactor1).to have_received(:rollback)
        expect(interactor2).to have_received(:rollback)
      end

      context 'when instance has already rolled back' do
        before { instance.instance_variable_set('@_rolled_back', true) }

        it 'is expected not to call rollback on called interactors' do
          subject
          expect(interactor1).not_to have_received(:rollback)
          expect(interactor2).not_to have_received(:rollback)
        end
      end
    end
  end

  describe '#rolled_back?' do
    subject { instance.rolled_back? }
    let(:instance) { described_class.new }

    it { is_expected.to eq false }

    context 'after #rollback! is called' do
      before { instance.rollback! }

      it { is_expected.to eq true }
    end
  end

  describe '#success?' do
    subject { instance.success? }
    let(:instance) { described_class.new }

    it { is_expected.to eq true }

    context 'after #fail! is called' do
      before { instance.fail! }

      it { is_expected.to eq false }
    end
  end
end
