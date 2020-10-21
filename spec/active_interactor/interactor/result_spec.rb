# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor::Result do
  describe '#fail!' do
    subject(:fail!) { result.fail!(errors) }

    let(:result) { described_class.new(context_object) }
    let(:context_object) { build_context.new }
    let(:errors) { nil }

    it { expect { fail! }.to raise_error(ActiveInteractor::Error::ContextFailure) }

    it 'is expected to be a failure' do
      fail!
    rescue ActiveInteractor::Error::ContextFailure
      expect(result).to be_a_failure
    end

    context 'when errors is a String' do
      let(:errors) { 'My Test Error' }

      it 'is expected to have error on :context' do
        fail!
      rescue ActiveInteractor::Error::ContextFailure
        expect(result.errors[:context]).to eq [errors]
      end
    end

    context 'when errors is a ActiveModel::Errors' do
      before { context_object.errors.add(:test, 'My Test Error') }

      let(:errors) { context_object.errors }

      it 'is expected to merge errors' do
        fail!
      rescue ActiveInteractor::Error::ContextFailure
        expect(result.errors[:test]).to eq ['My Test Error']
      end
    end

    context 'when errors is a Hash' do
      let(:errors) { { test_1: 'My Test Error 1', test_2: 'My Test Error 2' } }

      it 'is expected to add an error for each key pair' do
        fail!
      rescue ActiveInteractor::Error::ContextFailure
        expect(result.errors[:test_1]).to eq ['My Test Error 1']
        expect(result.errors[:test_2]).to eq ['My Test Error 2']
      end
    end

    context 'when errors is an array' do
      before { context_object.errors.add(:test_context, 'My Test Context Error') }

      let(:errors) do
        [
          'My Test String Error',
          context_object.errors,
          { test_hash: 'My Test Hash Error' }
        ]
      end

      it 'is expected to appropriately handle each value' do
        fail!
      rescue ActiveInteractor::Error::ContextFailure
        expect(result.errors[:context]).to eq ['My Test String Error']
        expect(result.errors[:test_context]).to eq ['My Test Context Error']
        expect(result.errors[:test_hash]).to eq ['My Test Hash Error']
      end
    end

    context 'when duplicate errors exist' do
      before { context_object.errors.add(:test, 'My Test Error') }

      let(:errors) { { test: 'My Test Error' } }

      it 'is expected to return unique errors' do
        fail!
      rescue ActiveInteractor::Error::ContextFailure
        expect(result.errors[:test].count).to eq 1
        expect(result.errors[:test]).to eq ['My Test Error']
      end
    end
  end

  describe '#rollback!' do
    subject(:rollback!) { result.rollback! }

    let(:result) { described_class.new(context_object) }
    let(:context_object) { build_context.new }

    context 'with #called! interactors' do
      before do
        [interactor1, interactor2].each { |interactor| result.state.called!(interactor) }
      end

      let(:interactor1) { instance_double('ActiveInteractor::Base', rollback: true) }
      let(:interactor2) { instance_double('ActiveInteractor::Base', rollback: true) }

      it { is_expected.to eq true }

      it 'is expected to rollback each interactor in reverse order' do
        rollback!

        expect(interactor2).to have_received(:rollback).ordered
        expect(interactor1).to have_received(:rollback).ordered
      end

      it 'is expected to rollback each interactor once' do
        rollback!
        rollback!

        expect(interactor2).to have_received(:rollback).once
        expect(interactor1).to have_received(:rollback).once
      end
    end
  end
end
