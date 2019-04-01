# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor::Worker do
  context 'with an interactor instance' do
    subject(:worker) { described_class.new(interactor) }
    let(:interactor) { build_interactor.new }

    describe '#execute_perform' do
      subject { worker.execute_perform }

      it { expect { subject }.not_to raise_error }
      it { should be_an ActiveInteractor::Context::Base }
      it 'should invoke `#execute_perform`' do
        expect(worker).to receive(:execute_perform!).and_call_original
        subject
      end

      context 'when `#execute_perform!` raises `ActiveInteractor::Context::Failure`' do
        before do
          error = ActiveInteractor::Context::Failure.new
          allow(ActiveInteractor.logger).to receive(:error).and_return(true)
          expect(worker).to receive(:execute_perform!).and_raise(error)
        end

        it { expect { subject }.not_to raise_error }
        it { should be_an ActiveInteractor::Context::Base }
      end
    end

    describe '#execute_perform!' do
      subject { worker.execute_perform! }

      it { should be_an ActiveInteractor::Context::Base }

      it 'should invoke `#run_callbacks` on the interactor' do
        expect_any_instance_of(interactor.class).to receive(:run_callbacks)
          .exactly(3).times
          .and_call_original
        subject
      end

      it 'should check context validation' do
        expect_any_instance_of(interactor.class.context_class).to receive(:valid?)
          .twice
          .and_call_original
        subject
      end

      it 'should invoke `#perform` on the interactor' do
        expect_any_instance_of(interactor.class).to receive(:perform)
          .and_call_original
        subject
      end
    end

    describe '#execute_rollback' do
      subject { worker.execute_rollback }

      it 'should invoke `#run_callbacks` on the interactor' do
        expect_any_instance_of(interactor.class).to receive(:run_callbacks)
          .with(:rollback)
          .and_call_original
        subject
      end

      it 'should invoke `#rollback` on the interactor' do
        expect_any_instance_of(interactor.class).to receive(:rollback)
        subject
      end
    end
  end
end
