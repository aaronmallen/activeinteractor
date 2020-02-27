# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::State do
  describe '#new' do
    subject { described_class.new }

    it { is_expected.to have_attributes(called: []) }
  end

  describe '#called!' do
    subject { instance.called!(interactor) }
    let(:instance) { described_class.new }

    context 'with an object that responds to :rollback' do
      let(:interactor) { double(rollback: true) }

      it { expect { subject }.to(change { instance.called }.to([interactor])) }
    end

    context 'with an object that does not respond to :rollback' do
      let(:interactor) { 'foo' }

      it { expect { subject }.not_to(change { instance.called }) }
    end
  end

  describe '#fail!' do
    subject { instance.fail!(errors) }
    let(:instance) { described_class.new }

    context 'with errors nil' do
      let(:errors) { nil }

      it { is_expected.to be_failure }
      it { expect { subject }.not_to(change { instance.errors }) }
    end

    context 'with errors "Test Error"' do
      let(:errors) { 'Test Error' }

      it { is_expected.to be_failure }
      it { expect { subject }.to(change { instance.errors.count }.by(1)) }
      it 'is expected to have errors on :interaction' do
        expect(subject.errors[:interaction]).to include errors
      end
    end

    context 'with errors being an instance of ActiveModel::Errors' do
      let(:error_class) do
        build_class('ErrorClass') do
          def errors
            @errors ||= ActiveModel::Errors.new(self)
          end
        end
        ErrorClass.new
      end

      context 'having no errors' do
        let(:errors) { error_class.errors }

        it { is_expected.to be_failure }
        it { expect { subject }.not_to(change { instance.errors }) }
      end

      context 'having errors :test => "Test Error"' do
        let(:errors) do
          error_class.errors.add(:test, 'Test Error')
          error_class.errors
        end

        it { is_expected.to be_failure }
        it 'is expected to have errors on :test' do
          expect(subject.errors[:test]).to include 'Test Error'
        end
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

    context 'with no called interactors' do
      let(:instance) { described_class.new }

      it { is_expected.not_to be_rolled_back }
    end

    context 'with two(2) called interactors' do
      let(:instance) { described_class.new }
      let(:interactor1) { double(rollback: true) }
      let(:interactor2) { double(rollback: true) }

      before do
        instance.called!(interactor1)
        instance.called!(interactor2)
      end

      it { is_expected.to be_rolled_back }
      it 'is expected to #rollback #called interactors in reverse order' do
        subject
        expect(interactor2).to have_received(:rollback).exactly(:once).ordered
        expect(interactor1).to have_received(:rollback).exactly(:once).ordered
      end

      context 'having been previously rolled back' do
        before { instance.instance_variable_set('@_rolled_back', true) }

        it { is_expected.to be_rolled_back }
        it 'is expected not to #rollback #called interactors' do
          subject
          expect(interactor2).not_to have_received(:rollback)
          expect(interactor1).not_to have_received(:rollback)
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

      it { is_expected.to eq false }

      context 'with #called interactors' do
        let(:interactor) { double(rollback: true) }
        before do
          instance.called!(interactor)
          instance.rollback!
        end

        it { is_expected.to eq true }
      end
    end
  end

  describe '#successful?' do
    subject { instance.successful? }
    let(:instance) { described_class.new }

    it { is_expected.to eq true }

    context 'after #fail! is called' do
      before { instance.fail! }

      it { is_expected.to eq false }
    end
  end
end
