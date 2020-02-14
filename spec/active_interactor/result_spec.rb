# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Result do
  context 'when context responds to :foo' do
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    before do
      mock_context = build_context.new(foo: 'foo')
      allow_any_instance_of(described_class).to receive(:context)
        .and_return(mock_context)
    end

    describe '#foo' do
      subject { described_class.new(interactor, state).foo }

      it { expect { subject }.not_to raise_error }
      it 'is expected to warn about deprecation' do
        expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
          .with(
            'calling context methods on an ActiveInteractor::Result',
            'use result.context.foo instead'
          )
        subject
      end
    end

    describe '#respond_to?' do
      subject { described_class.new(interactor, state).respond_to?(:foo) }

      it { is_expected.to eq true }
      it 'is expected to warn about deprecation' do
        expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
          .with(
            'calling context methods on an ActiveInteractor::Result',
            'use result.context.foo instead'
          )
        subject
      end
    end
  end

  describe '#fail?' do
    subject { described_class.new(interactor, state).fail? }
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    it { is_expected.to eq false }
    it 'is expected to warn about deprecation' do
      expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
        .with(
          'calling state methods on an ActiveInteractor::Result',
          'use result.state.fail? instead'
        )
      subject
    end

    context 'when state is failure' do
      let(:state) { ActiveInteractor::State::Manager.new.fail! }
      it { is_expected.to eq true }
    end

    context 'when context is failure' do
      before do
        allow_any_instance_of(described_class).to receive(:context)
          .and_return(double(failure?: true))
      end

      it { is_expected.to eq true }
    end
  end

  describe '#failure?' do
    subject { described_class.new(interactor, state).failure? }
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    it { is_expected.to eq false }
    it 'is expected to warn about deprecation' do
      expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
        .with(
          'calling state methods on an ActiveInteractor::Result',
          'use result.state.failure? instead'
        )
      subject
    end

    context 'when state is failure' do
      let(:state) { ActiveInteractor::State::Manager.new.fail! }
      it { is_expected.to eq true }
    end

    context 'when context is failure' do
      before do
        allow_any_instance_of(described_class).to receive(:context)
          .and_return(double(failure?: true))
      end

      it { is_expected.to eq true }
    end
  end

  describe '#resolve' do
    subject { described_class.new(interactor, state).resolve }
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    context 'when context is invalid' do
      before do
        mock_context = build_context do
          validates :foo, presence: true
        end

        allow_any_instance_of(described_class).to receive(:context)
          .and_return(mock_context.new)
      end

      it 'is expected to #fail! state' do
        expect(state).to receive(:fail!)
        subject
      end

      it 'is expected to have context errors' do
        expect(subject.errors[:foo]).not_to be_nil
        expect(subject.errors[:foo]).to include "can't be blank"
      end

      context 'with interactor.options :validate => false' do
        let(:interactor) { build_interactor.new.with_options(validate: false) }

        it 'is expected not to #fail! state' do
          expect(state).not_to receive(:fail!)
        end
      end
    end

    context 'when context has errors' do
      let(:interactor) { build_interactor.new.with_options(validate: false) }
      before do
        mock_context = build_context.new
        mock_context.errors.add(:foo, 'invalid')
        allow_any_instance_of(described_class).to receive(:context)
          .and_return(mock_context)
      end

      it 'is expected to have context errors' do
        expect(subject.errors[:foo]).not_to be_nil
        expect(subject.errors[:foo]).to include 'invalid'
      end
    end

    context 'when state has errors' do
      let(:state) do
        state = ActiveInteractor::State::Manager.new
        state.errors.add(:foo, 'invalid')
        state
      end

      it 'is expected to have state errors' do
        expect(subject.errors[:foo]).not_to be_nil
        expect(subject.errors[:foo]).to include 'invalid'
      end
    end

    context 'when both state and context have errors' do
      let(:interactor) { build_interactor.new.with_options(validate: false) }

      context 'on the same attribute with the same error' do
        before do
          mock_context = build_context.new
          mock_context.errors.add(:foo, 'invalid')
          allow_any_instance_of(described_class).to receive(:context)
            .and_return(mock_context)
        end

        let(:state) do
          state = ActiveInteractor::State::Manager.new
          state.errors.add(:foo, 'invalid')
          state
        end

        it 'is expected to have approriate errors' do
          expect(subject.errors[:foo]).not_to be_nil
          expect(subject.errors[:foo]).to include 'invalid'
        end

        it 'is expected to have exactly 1 error' do
          expect(subject.errors[:foo].count).to eq 1
        end
      end

      context 'on the same attribute with the different error' do
        before do
          mock_context = build_context.new
          mock_context.errors.add(:foo, "can't be blank")
          allow_any_instance_of(described_class).to receive(:context)
            .and_return(mock_context)
        end

        let(:state) do
          state = ActiveInteractor::State::Manager.new
          state.errors.add(:foo, 'invalid')
          state
        end

        it 'is expected to have approriate errors' do
          expect(subject.errors[:foo]).not_to be_nil
          expect(subject.errors[:foo]).to include 'invalid'
          expect(subject.errors[:foo]).to include "can't be blank"
        end

        it 'is expected to have exactly 2 error' do
          expect(subject.errors[:foo].count).to eq 2
        end
      end

      context 'on diffrent attributes' do
        before do
          mock_context = build_context.new
          mock_context.errors.add(:foo, 'invalid')
          allow_any_instance_of(described_class).to receive(:context)
            .and_return(mock_context)
        end

        let(:state) do
          state = ActiveInteractor::State::Manager.new
          state.errors.add(:bar, 'invalid')
          state
        end

        it 'is expected to have approriate errors' do
          expect(subject.errors[:foo]).not_to be_nil
          expect(subject.errors[:bar]).not_to be_nil
          expect(subject.errors[:foo]).to include 'invalid'
          expect(subject.errors[:bar]).to include 'invalid'
        end
      end
    end
  end

  describe '#success?' do
    subject { described_class.new(interactor, state).success? }
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    it { is_expected.to eq true }
    it 'is expected to warn about deprecation' do
      expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
        .with(
          'calling state methods on an ActiveInteractor::Result',
          'use result.state.success? instead'
        )
      subject
    end

    context 'when state is failure' do
      let(:state) { ActiveInteractor::State::Manager.new.fail! }
      it { is_expected.to eq false }
    end

    context 'when context is failure' do
      before do
        allow_any_instance_of(described_class).to receive(:context)
          .and_return(double(success?: false))
      end

      it { is_expected.to eq false }
    end
  end

  describe '#successful?' do
    subject { described_class.new(interactor, state).successful? }
    let(:interactor) { build_interactor.new }
    let(:state) { ActiveInteractor::State::Manager.new }

    it { is_expected.to eq true }
    it 'is expected to warn about deprecation' do
      expect(ActiveInteractor::NextMajorDeprecator).to receive(:deprecation_warning)
        .with(
          'calling state methods on an ActiveInteractor::Result',
          'use result.state.successful? instead'
        )
      subject
    end

    context 'when state is failure' do
      let(:state) { ActiveInteractor::State::Manager.new.fail! }
      it { is_expected.to eq false }
    end

    context 'when context is failure' do
      before do
        allow_any_instance_of(described_class).to receive(:context)
          .and_return(double(success?: false))
      end

      it { is_expected.to eq false }
    end
  end
end
