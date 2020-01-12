# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Organizer do
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

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a symbol' do
        let(:klass) { :test_context }

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a constant' do
        let(:klass) { TestContext }

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end
    end
  end

  describe '.organize' do
    subject { interactor_class }
    context 'with two existing interactors' do
      let!(:interactor1) { build_interactor('TestInteractor1') }
      let!(:interactor2) { build_interactor('TestInteractor2') }

      context 'when interactors are passed as contants' do
        let(:interactor_class) do
          build_organizer do
            organize TestInteractor1, TestInteractor2
          end
        end

        it { is_expected.to have_attributes(organized: [TestInteractor1, TestInteractor2]) }
      end

      context 'when interactors are passed as symbols' do
        let(:interactor_class) do
          build_organizer do
            organize :test_interactor_1, :test_interactor_2
          end
        end

        it { is_expected.to have_attributes(organized: [TestInteractor1, TestInteractor2]) }

        context 'having a non existance interactor' do
          let(:interactor_class) do
            build_organizer do
              organize :test_interactor_1, :interactor_that_doesnt_exist, :test_interactor_2
            end
          end

          it { is_expected.to have_attributes(organized: [TestInteractor1, TestInteractor2]) }
        end
      end

      context 'when interactors are passed as strings' do
        let(:interactor_class) do
          build_organizer do
            organize 'TestInteractor1', 'TestInteractor2'
          end
        end

        it { is_expected.to have_attributes(organized: [TestInteractor1, TestInteractor2]) }

        context 'having a non existance interactor' do
          let(:interactor_class) do
            build_organizer do
              organize 'TestInteractor1', 'InteractorThatDoesntExist', 'TestInteractor2'
            end
          end

          it { is_expected.to have_attributes(organized: [TestInteractor1, TestInteractor2]) }
        end
      end
    end
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

      it { is_expected.to be_a interactor_class.context_class }
      it 'is expected to call #perform on both interactors' do
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
        it { is_expected.to be_a interactor_class.context_class }
        it 'is expected to call #perform on the first interactor' do
          expect_any_instance_of(interactor1).to receive(:perform)
          subject
        end
        it 'is expected to not call #perform on the second interactor' do
          expect_any_instance_of(interactor2).not_to receive(:perform)
          subject
        end
        it 'is expected to call #rollback on the first interactor' do
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
        it { is_expected.to be_a interactor_class.context_class }
        it 'is expected to call #perform on both interactors' do
          expect_any_instance_of(interactor1).to receive(:perform)
          expect_any_instance_of(interactor2).to receive(:perform)
          subject
        end
        it 'is expected to call #rollback on both interactors' do
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

        it { is_expected.to be_a interactor_class.context_class }
        it 'is expected to call #perform on both interactors' do
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
          it { is_expected.to be_a interactor_class.context_class }
          it 'is expected to call #perform on both interactors' do
            expect_any_instance_of(interactor1).to receive(:perform)
            expect_any_instance_of(interactor2).to receive(:perform)
            subject
          end
          it 'is expected to call #rollback both interactors' do
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
          it { is_expected.to be_a interactor_class.context_class }
          it 'is expected to call #perform on both interactors' do
            expect_any_instance_of(interactor1).to receive(:perform)
            expect_any_instance_of(interactor2).to receive(:perform)
            subject
          end
          it 'is expected to call #rollback on both interactors' do
            expect_any_instance_of(interactor1).to receive(:rollback)
            expect_any_instance_of(interactor2).to receive(:rollback)
            subject
          end
        end
      end
    end
  end
end
