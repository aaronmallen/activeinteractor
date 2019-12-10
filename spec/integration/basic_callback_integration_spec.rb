# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Basic Callback Integration', type: :integration do
  describe 'An interactor with after context validation callbacks' do
    let(:interactor_class) do
      build_interactor do
        context_validates :test_field, presence: true
        after_context_validation :downcase_test_field

        private

        def downcase_test_field
          context.test_field = context.test_field.downcase
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with valid context attributes' do
        let(:context_attributes) { { test_field: 'TEST' } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'test') }
      end
    end
  end

  describe 'An interactor with conditional after context validation callbacks' do
    let(:interactor_class) do
      build_interactor do
        context_validates :test_field, presence: true
        after_context_validation :downcase_test_field, if: -> { context.should_downcase }

        private

        def downcase_test_field
          context.test_field = context.test_field.downcase
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with :test_field "TEST" and :should_downcase true' do
        let(:context_attributes) { { test_field: 'TEST', should_downcase: true } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'test') }
      end

      context 'with :test_field "TEST" and :should_downcase false' do
        let(:context_attributes) { { test_field: 'TEST', should_downcase: false } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'TEST') }
      end
    end
  end

  describe 'An interactor with after perform callbacks' do
    let(:interactor_class) do
      build_interactor do
        after_perform :test_after_perform

        private

        def test_after_perform; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it 'is expected to call #test_after_perform' do
        expect_any_instance_of(interactor_class).to receive(:test_after_perform)
        subject
      end
    end
  end

  describe 'An interactor with after rollback callbacks' do
    let(:interactor_class) do
      build_interactor do
        after_rollback :test_after_rollback

        def perform
          context.fail!
        end

        private

        def test_after_rollback; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it 'is expected to call #test_after_rollback' do
        expect_any_instance_of(interactor_class).to receive(:test_after_rollback)
        subject
      end
    end
  end

  describe 'An interactor with around perform callbacks' do
    let(:interactor_class) do
      build_interactor do
        around_perform :test_around_perform

        def perform
          context.perform_step << 2
        end

        private

        def test_around_perform
          context.perform_step = []
          context.perform_step << 1
          yield
          context.perform_step << 3
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to have_attributes(perform_step: [1, 2, 3]) }
    end
  end

  describe 'An interactor with around rollback callbacks' do
    let(:interactor_class) do
      build_interactor do
        around_rollback :test_around_rollback

        def perform
          context.fail!
        end

        def rollback
          context.rollback_step << 2
        end

        private

        def test_around_rollback
          context.rollback_step = []
          context.rollback_step << 1
          yield
          context.rollback_step << 3
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to have_attributes(rollback_step: [1, 2, 3]) }
    end
  end

  describe 'An interactor with before perform callbacks' do
    let(:interactor_class) do
      build_interactor do
        before_perform :test_before_perform

        private

        def test_before_perform; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it 'is expected to call #test_before_perform' do
        expect_any_instance_of(interactor_class).to receive(:test_before_perform)
        subject
      end
    end
  end

  describe 'An interactor with before rollback callbacks' do
    let(:interactor_class) do
      build_interactor do
        before_rollback :test_before_rollback

        def perform
          context.fail!
        end

        private

        def test_before_rollback; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it 'is expected to call #test_before_rollback' do
        expect_any_instance_of(interactor_class).to receive(:test_before_rollback)
        subject
      end
    end
  end

  describe 'An organizer with after each callbacks' do
    let!(:interactor1) { build_interactor('TestInteractor1') }
    let!(:interactor2) { build_interactor('TestInteractor2') }
    let(:interactor_class) do
      build_organizer do
        after_each_perform :test_after_each_perform
        organize TestInteractor1, TestInteractor2

        private

        def test_after_each_perform; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it 'is expected to call #test_after_each_perform twice' do
        expect_any_instance_of(interactor_class).to receive(:test_after_each_perform)
          .exactly(:twice)
        subject
      end
    end
  end

  describe 'An organizer with around each callbacks' do
    let!(:interactor1) { build_interactor('TestInteractor1') }
    let!(:interactor2) { build_interactor('TestInteractor2') }
    let(:interactor_class) do
      build_organizer do
        around_each_perform :test_around_each_perform
        organize TestInteractor1, TestInteractor2

        private

        def find_index
          (context.around_each_step.last || 0) + 1
        end

        def test_around_each_perform
          context.around_each_step ||= []
          context.around_each_step << find_index
          yield
          context.around_each_step << find_index
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to have_attributes(around_each_step: [1, 2, 3, 4]) }
    end
  end

  describe 'An organizer with before each callbacks' do
    let!(:interactor1) { build_interactor('TestInteractor1') }
    let!(:interactor2) { build_interactor('TestInteractor2') }
    let(:interactor_class) do
      build_organizer do
        before_each_perform :test_before_each_perform
        organize TestInteractor1, TestInteractor2

        private

        def test_before_each_perform; end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it 'is expected to call #test_before_each_perform twice' do
        expect_any_instance_of(interactor_class).to receive(:test_before_each_perform)
          .exactly(:twice)
        subject
      end
    end
  end
end
