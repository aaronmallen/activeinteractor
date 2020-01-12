# frozen_string_literal: true

require 'spec_helper'
require 'active_interactor/interactor/worker'

RSpec.describe ActiveInteractor::Interactor::Worker do
  context 'with interactor class TestInteractor' do
    before { build_interactor }
    let(:interactor) { TestInteractor.new }

    describe '#execute_perform' do
      subject { described_class.new(interactor).execute_perform }

      it { is_expected.to be_an TestInteractor.context_class }

      context 'when context fails' do
        before do
          allow_any_instance_of(TestInteractor).to receive(:perform)
            .and_raise(ActiveInteractor::Error::ContextFailure)
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.to be_an TestInteractor.context_class }
      end
    end

    describe '#execute_perform!' do
      subject { described_class.new(interactor).execute_perform! }

      it { is_expected.to be_an TestInteractor.context_class }

      it 'is expected to run perform callbacks on interactor' do
        expect_any_instance_of(TestInteractor).to receive(:run_callbacks)
          .with(:perform)
        subject
      end

      it 'calls #perform on interactor instance' do
        expect_any_instance_of(TestInteractor).to receive(:perform)
        subject
      end

      context 'with options :skip_perform_callbacks eq to true' do
        subject { described_class.new(interactor).execute_perform!(skip_perform_callbacks: true) }

        it 'is expected not to run perform callbacks on interactor' do
          allow_any_instance_of(TestInteractor).to receive(:run_callbacks)
            .with(:validation).and_call_original
          expect_any_instance_of(TestInteractor).not_to receive(:run_callbacks)
            .with(:perform)
          subject
        end

        it 'calls #perform on interactor instance' do
          expect_any_instance_of(TestInteractor).to receive(:perform)
          subject
        end
      end

      context 'when interactor context is invalid on :calling' do
        before do
          allow_any_instance_of(TestInteractor.context_class).to receive(:valid?)
            .with(:calling)
            .and_return(false)
          allow_any_instance_of(TestInteractor.context_class).to receive(:valid?)
            .with(:called)
            .and_return(true)
        end

        it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }
        it 'rollsback the interactor context' do
          expect_any_instance_of(TestInteractor).to receive(:context_rollback!)
          expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure)
        end

        context 'with options :validate eq to false' do
          subject { described_class.new(interactor).execute_perform!(validate: false) }

          it { expect { subject }.not_to raise_error }
          it 'is expected not to run validation callbacks on interactor' do
            expect_any_instance_of(TestInteractor).not_to receive(:run_callbacks)
              .with(:validation)
            subject
          end
        end

        context 'with options :validate_on_calling eq to false' do
          subject { described_class.new(interactor).execute_perform!(validate_on_calling: false) }

          it { expect { subject }.not_to raise_error }
          it 'is expected not to call valid? with :calling' do
            expect_any_instance_of(TestInteractor.context_class).not_to receive(:valid?)
              .with(:calling)
            subject
          end
          it 'is expected to call valid? with :called' do
            expect_any_instance_of(TestInteractor.context_class).to receive(:valid?)
              .with(:called)
            subject
          end
        end
      end

      context 'when interactor context is invalid on :called' do
        before do
          allow_any_instance_of(TestInteractor.context_class).to receive(:valid?)
            .with(:calling)
            .and_return(true)
          allow_any_instance_of(TestInteractor.context_class).to receive(:valid?)
            .with(:called)
            .and_return(false)
        end

        it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }
        it 'rollsback the interactor context' do
          expect_any_instance_of(TestInteractor).to receive(:context_rollback!)
          expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure)
        end

        context 'with options :validate eq to false' do
          subject { described_class.new(interactor).execute_perform!(validate: false) }

          it { expect { subject }.not_to raise_error }
          it 'is expected not to run validation callbacks on interactor' do
            expect_any_instance_of(TestInteractor).not_to receive(:run_callbacks)
              .with(:validation)
            subject
          end
        end

        context 'with options :validate_on_called eq to false' do
          subject { described_class.new(interactor).execute_perform!(validate_on_called: false) }

          it { expect { subject }.not_to raise_error }
          it 'is expected to call valid? with :calling' do
            expect_any_instance_of(TestInteractor.context_class).to receive(:valid?)
              .with(:calling)
            subject
          end
          it 'is expected not to call valid? with :called' do
            expect_any_instance_of(TestInteractor.context_class).not_to receive(:valid?)
              .with(:called)
            subject
          end
        end
      end
    end

    describe '#execute_rollback' do
      subject { described_class.new(interactor).execute_rollback }

      it 'is expected to run rollback callbacks on interactor' do
        expect_any_instance_of(TestInteractor).to receive(:run_callbacks)
          .with(:rollback)
        subject
      end

      it 'calls #context_rollback on interactor instance' do
        expect_any_instance_of(TestInteractor).to receive(:context_rollback!)
        subject
      end

      context 'with options :skip_rollback eq to true' do
        subject { described_class.new(interactor).execute_rollback(skip_rollback: true) }

        it 'is expected not to call #context_rollback on interactor instance' do
          expect_any_instance_of(TestInteractor).not_to receive(:context_rollback!)
          subject
        end
      end

      context 'with options :skip_rollback_callbacks eq to true' do
        subject { described_class.new(interactor).execute_rollback(skip_rollback_callbacks: true) }

        it 'is expected not to run rollback callbacks on interactor' do
          expect_any_instance_of(TestInteractor).not_to receive(:run_callbacks)
            .with(:rollback)
          subject
        end

        it 'calls #context_rollback on interactor instance' do
          expect_any_instance_of(TestInteractor).to receive(:context_rollback!)
          subject
        end
      end
    end
  end
end
