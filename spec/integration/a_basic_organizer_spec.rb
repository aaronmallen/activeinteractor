# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A basic organizer', type: :integration do
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

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a interactor_class.context_class }
    it { is_expected.to be_successful }
    it { is_expected.to have_attributes(test_field_1: 'test 1', test_field_2: 'test 2') }
  end

  context 'when the first interactor fails' do
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.fail!
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to receive #rollback on the first interactor' do
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
          .and_call_original
        subject
      end
      it 'is expected not to receive #perform! on the second interactor' do
        expect_any_instance_of(test_interactor_2).not_to receive(:perform!)
        subject
      end
    end
  end

  context 'when the second interactor fails' do
    let!(:test_interactor_2) do
      build_interactor('TestInteractor2') do
        def perform
          context.fail!
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to receive #rollback on all interactors' do
        expect_any_instance_of(test_interactor_2).to receive(:rollback)
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
        subject
      end
    end
  end

  # https://github.com/aaronmallen/activeinteractor/issues/151
  context 'with an interactor having a predefined context with attributes [:foo]' do
    let!(:test_context_class) do
      build_context('TestInteractor1Context') do
        attributes :foo
      end
    end
    let!(:test_interactor_1) { build_interactor('TestInteractor1') }
    let(:interactor_class) do
      build_organizer do
        organize :test_interactor_1
      end
    end

    context 'when passing a context argument { :foo => "foo" }' do
      let(:context_attributes) { { foo: 'foo' } }

      describe '.perform' do
        subject { interactor_class.perform(context_attributes) }
        it { is_expected.to have_attributes(foo: 'foo') }
      end
    end
  end
end
