# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Basic Integration', type: :integration do
  describe 'A basic interactor' do
    let(:interactor_class) do
      build_interactor do
        def perform
          context.test_field = 'test'
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.context_class' do
      subject { interactor_class.context_class }

      it { is_expected.to eq TestInteractor::Context }
      it { is_expected.to be < ActiveInteractor::Context::Base }
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field: 'test') }
    end

    describe '.perform!' do
      subject { interactor_class.perform! }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field: 'test') }
    end
  end

  describe 'A failing interactor' do
    let(:interactor_class) do
      build_interactor do
        def perform
          context.fail!
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.context_class' do
      subject { interactor_class.context_class }

      it { is_expected.to eq TestInteractor::Context }
      it { is_expected.to be < ActiveInteractor::Context::Base }
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to #rollback' do
        expect_any_instance_of(interactor_class).to receive(:rollback)
        subject
      end
    end

    describe '.perform!' do
      subject { interactor_class.perform! }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }
    end
  end

  describe 'A basic organizer' do
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.test_field_1 = 'test 1'
        end
      end
    end

    let!(:test_interactor_2) do
      build_interactor('TestInteractor2') do
        def perform
          context.test_field_2 = 'test 2'
        end
      end
    end

    let(:interactor_class) do
      build_organizer do
        organize TestInteractor1, TestInteractor2
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.context_class' do
      subject { interactor_class.context_class }

      it { is_expected.to eq TestOrganizer::Context }
      it { is_expected.to be < ActiveInteractor::Context::Base }
    end

    describe '.organized' do
      subject { interactor_class.organized }

      it { is_expected.to eq [TestInteractor1, TestInteractor2] }
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field_1: 'test 1', test_field_2: 'test 2') }
    end
  end

  describe 'A basic organizer having the first interactor fail' do
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.fail!
        end
      end
    end

    let!(:test_interactor_2) do
      build_interactor('TestInteractor2') do
        def perform
          context.test_field_2 = 'test 2'
        end
      end
    end

    let(:interactor_class) do
      build_organizer do
        organize TestInteractor1, TestInteractor2
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to rollback the first interactor' do
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
          .and_call_original
        subject
      end
      it 'is expected not to call #perform! on the second interactor' do
        expect_any_instance_of(test_interactor_2).not_to receive(:perform!)
        subject
      end
    end
  end

  describe 'A basic organizer having the second interactor fail' do
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.test_field_1 = 'test 1'
        end
      end
    end

    let!(:test_interactor_2) do
      build_interactor('TestInteractor2') do
        def perform
          context.fail!
        end
      end
    end

    let(:interactor_class) do
      build_organizer do
        organize TestInteractor1, TestInteractor2
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to rollback all interactors' do
        expect_any_instance_of(test_interactor_2).to receive(:rollback)
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
        subject
      end
    end
  end
end
