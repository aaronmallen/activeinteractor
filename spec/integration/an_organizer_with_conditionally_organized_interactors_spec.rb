# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with conditionally organized interactors', type: :integration do
  let!(:test_interactor_1) { build_interactor('TestInteractor1') }
  let!(:test_interactor_2)  { build_interactor('TestInteractor2') }

  context 'with a condition on the first interactor { :if => -> { context.test_1 } } ' \
  'and a condition on the second interactor { :if => -> { context.test_2 } }' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, if: -> { context.test_1 }
          add :test_interactor_2, if: -> { context.test_2 }
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with context_attributes test_1 and test_2 both eq to true' do
        let(:context_attributes) { { test_1: true, test_2: true } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected to receive #perform on both interactors' do
          expect_any_instance_of(test_interactor_1).to receive(:perform)
          expect_any_instance_of(test_interactor_2).to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 eq to true and test_2 eq to false' do
        let(:context_attributes) { { test_1: true, test_2: false } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).to receive(:perform)
          subject
        end

        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_2).not_to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 eq to false and test_2 eq to true' do
        let(:context_attributes) { { test_1: false, test_2: true } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).not_to receive(:perform)
          subject
        end

        it 'is expected to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_2).to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 and test_2 both eq to false' do
        let(:context_attributes) { { test_1: false, test_2: false } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).not_to receive(:perform)
          subject
        end

        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_2).not_to receive(:perform)
          subject
        end
      end
    end
  end

  context 'with a condition on the first interactor { :unless => -> { context.test_1 } } ' \
  'and a condition on the second interactor { :unless => -> { context.test_2 } }' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, unless: -> { context.test_1 }
          add :test_interactor_2, unless: -> { context.test_2 }
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with context_attributes test_1 and test_2 both eq to true' do
        let(:context_attributes) { { test_1: true, test_2: true } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).not_to receive(:perform)
          subject
        end

        it 'is expected not to receive #perform on the second interactor' do
          expect_any_instance_of(test_interactor_2).not_to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 eq to true and test_2 eq to false' do
        let(:context_attributes) { { test_1: true, test_2: false } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected not to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).not_to receive(:perform)
          subject
        end

        it 'is expected to receive #perform on the second interactor' do
          expect_any_instance_of(test_interactor_2).to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 eq to false and test_2 eq to true' do
        let(:context_attributes) { { test_1: false, test_2: true } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected to receive #perform on the first interactor' do
          expect_any_instance_of(test_interactor_1).to receive(:perform)
          subject
        end

        it 'is expected not to receive #perform on the second interactor' do
          expect_any_instance_of(test_interactor_2).not_to receive(:perform)
          subject
        end
      end

      context 'with context_attributes test_1 and test_2 both eq to false' do
        let(:context_attributes) { { test_1: false, test_2: false } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it 'is expected to receive #perform on both interactors' do
          expect_any_instance_of(test_interactor_1).to receive(:perform)
          expect_any_instance_of(test_interactor_2).to receive(:perform)
          subject
        end
      end
    end
  end

  context 'with a condition on the first interactor { :if => :test_method } and :test_method returning true' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, if: :test_method
          add :test_interactor_2
        end

        private

        def test_method
          true
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
      it 'is expected to receive #perform on both interactors' do
        expect_any_instance_of(test_interactor_1).to receive(:perform)
        expect_any_instance_of(test_interactor_2).to receive(:perform)
        subject
      end
    end
  end

  context 'with a condition on the first interactor { :if => :test_method } and :test_method returning false' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, if: :test_method
          add :test_interactor_2
        end

        private

        def test_method
          false
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
      it 'is expected not to receive #perform on the first interactor' do
        expect_any_instance_of(test_interactor_1).not_to receive(:perform)
        subject
      end

      it 'is expected to receive #perform on the second interactor' do
        expect_any_instance_of(test_interactor_2).to receive(:perform)
        subject
      end
    end
  end

  context 'with a condition on the first interactor { :unless => :test_method } and :test_method returning true' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, unless: :test_method
          add :test_interactor_2
        end

        private

        def test_method
          true
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
      it 'is expected not to receive #perform on the first interactor' do
        expect_any_instance_of(test_interactor_1).not_to receive(:perform)
        subject
      end

      it 'is expected to receive #perform on the second interactor' do
        expect_any_instance_of(test_interactor_2).to receive(:perform)
        subject
      end
    end
  end

  context 'with a condition on the first interactor { :unless => :test_method } and :test_method returning false' do
    let(:interactor_class) do
      build_organizer do
        organize do
          add :test_interactor_1, unless: :test_method
          add :test_interactor_2
        end

        private

        def test_method
          false
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'
    include_examples 'a class with organizer callback methods'

    describe '.perform' do
      subject { interactor_class.perform }

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
      it 'is expected to receive #perform on both interactors' do
        expect_any_instance_of(test_interactor_1).to receive(:perform)
        expect_any_instance_of(test_interactor_2).to receive(:perform)
        subject
      end
    end
  end
end
