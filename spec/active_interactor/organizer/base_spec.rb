# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Organizer::Base do
  let(:interactor_class) { described_class }
  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'
  include_examples 'a class with organizer callback methods'

  describe '.contextualize_with' do
    subject { described_class.contextualize_with(klass) }

    context 'with an class that does not exist' do
      let(:klass) { 'SomeClassThatDoesNotExist' }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::InvalidContextClass) }
    end

    context 'with context class TestContext' do
      before { build_context }

      context 'when passed as a string' do
        let(:klass) { 'TestContext' }

        it 'is expected to assign the appropriate context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a symbol' do
        let(:klass) { :test_context }

        it 'is expected to assign the appropriate context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a constant' do
        let(:klass) { TestContext }

        it 'is expected to assign the appropriate context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end
    end
  end

  describe '.organize' do
    context 'with two existing interactors' do
      let!(:interactor1) { build_interactor('TestInteractor1') }
      let!(:interactor2) { build_interactor('TestInteractor2') }

      context 'when interactors are passed as args' do
        let(:organizer) do
          build_organizer do
            organize :test_interactor_1, :test_interactor_2
          end
        end

        describe '.organized' do
          subject { organizer.organized }

          it { expect(subject.collection).to all(be_a ActiveInteractor::Organizer::InteractorInterface) }
          it 'is expected to organize the approriate interactors' do
            expect(subject.collection.first.interactor_class).to eq TestInteractor1
            expect(subject.collection.last.interactor_class).to eq TestInteractor2
          end
        end
      end

      context 'when a block is passed' do
        let(:organizer) do
          build_organizer do
            organize do
              add :test_interactor_1
              add :test_interactor_2
            end
          end
        end

        describe '.organized' do
          subject { organizer.organized }

          it { expect(subject.collection).to all(be_a ActiveInteractor::Organizer::InteractorInterface) }
          it 'is expected to organize the approriate interactors' do
            expect(subject.collection.first.interactor_class).to eq TestInteractor1
            expect(subject.collection.last.interactor_class).to eq TestInteractor2
          end
        end
      end
    end
  end

  describe '.perform_in_parallel' do
    subject do
      build_organizer do
        perform_in_parallel
      end
    end

    it { should have_attributes(parallel: true) }
  end

  describe '#perform' do
    subject { interactor_class.perform }
    context 'with two existing interactors' do
      let!(:interactor1) { build_interactor('TestInteractor1') }
      let!(:interactor2) { build_interactor('TestInteractor2') }
      let(:interactor_class) do
        build_organizer do
          organize TestInteractor1, TestInteractor2
        end
      end

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it 'is expected to receive #perform on both interactors' do
        expect_any_instance_of(interactor1).to receive(:perform)
        expect_any_instance_of(interactor2).to receive(:perform)
        subject
      end

      context 'with options :skip_each_perform_callbacks eq to true' do
        subject { interactor_class.perform({}, skip_each_perform_callbacks: true) }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it 'is expected to receive #perform on both interactors' do
          expect_any_instance_of(interactor1).to receive(:perform)
          expect_any_instance_of(interactor2).to receive(:perform)
          subject
        end
        it 'is expected not to receive #run_callbacks with :each_perform' do
          expect_any_instance_of(interactor_class).not_to receive(:run_callbacks)
            .with(:each_perform)
          subject
        end
      end

      context 'when the first interactor context fails' do
        let!(:interactor1) do
          build_interactor('TestInteractor1') do
            def perform
              context.fail!
            end
          end
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.to be_failure }
        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it 'is expected to receive #perform on the first interactor' do
          expect_any_instance_of(interactor1).to receive(:perform)
          subject
        end
        it 'is expected not to receive #perform on the second interactor' do
          expect_any_instance_of(interactor2).not_to receive(:perform)
          subject
        end
        it 'is expected to receive #rollback on the first interactor' do
          expect_any_instance_of(interactor1).to receive(:rollback)
          subject
        end
      end

      context 'when the second interactor context fails' do
        let!(:interactor2) do
          build_interactor('TestInteractor2') do
            def perform
              context.fail!
            end
          end
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.to be_failure }
        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it 'is expected to receive #perform on both interactors' do
          expect_any_instance_of(interactor1).to receive(:perform)
          expect_any_instance_of(interactor2).to receive(:perform)
          subject
        end
        it 'is expected to receive #rollback on both interactors' do
          expect_any_instance_of(interactor1).to receive(:rollback)
          expect_any_instance_of(interactor2).to receive(:rollback)
          subject
        end
      end

      context 'when the organizer is set to perform in parallel' do
        let(:interactor_class) do
          build_organizer do
            perform_in_parallel

            organize TestInteractor1, TestInteractor2
          end
        end

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it 'is expected to receive #perform on both interactors' do
          expect_any_instance_of(interactor1).to receive(:perform)
          expect_any_instance_of(interactor2).to receive(:perform)
          subject
        end

        context 'when the first interactor context fails' do
          let!(:interactor1) do
            build_interactor('TestInteractor1') do
              def perform
                context.fail!
              end
            end
          end

          it { expect { subject }.not_to raise_error }
          it { is_expected.to be_failure }
          it { is_expected.to be_a ActiveInteractor::Interactor::Result }
          it 'is expected to receive #perform on both interactors' do
            expect_any_instance_of(interactor1).to receive(:perform)
            expect_any_instance_of(interactor2).to receive(:perform)
            subject
          end
          it 'is expected to receive #rollback both interactors' do
            expect_any_instance_of(interactor1).to receive(:rollback)
            expect_any_instance_of(interactor2).to receive(:rollback)
            subject
          end
        end

        context 'when the second interactor context fails' do
          let!(:interactor2) do
            build_interactor('TestInteractor2') do
              def perform
                context.fail!
              end
            end
          end

          it { expect { subject }.not_to raise_error }
          it { is_expected.to be_failure }
          it { is_expected.to be_a ActiveInteractor::Interactor::Result }
          it 'is expected to receive #perform on both interactors' do
            expect_any_instance_of(interactor1).to receive(:perform)
            expect_any_instance_of(interactor2).to receive(:perform)
            subject
          end
          it 'is expected to receive #rollback on both interactors' do
            expect_any_instance_of(interactor1).to receive(:rollback)
            expect_any_instance_of(interactor2).to receive(:rollback)
            subject
          end
        end
      end
    end
  end
end
