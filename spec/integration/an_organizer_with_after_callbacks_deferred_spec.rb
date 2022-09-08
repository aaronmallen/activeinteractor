# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with after callbacks deferred', type: :integration do
  let!(:test_interactor_1) do
    build_interactor('TestInteractor1') do
      defer_after_callbacks_when_organized

      after_perform do
        context.after_perform_1a = context.after_perform_1b + 1
      end

      after_perform do
        context.after_perform_1b = context.after_perform_3a + 1 
      end

      def perform
        context.perform_1 = 1
      end
    end
  end

  let!(:test_interactor_2) do
    build_interactor('TestInteractor2') do
      defer_after_callbacks_when_organized

      after_perform do
        context.after_perform_2 = context.after_perform_1a + 1
      end

      def perform
        context.perform_2 = context.perform_1 + 1
      end
    end
  end

  let!(:test_interactor_3) do
    build_interactor('TestInteractor3') do
      after_perform do
        context.after_perform_3a = context.after_perform_3b + 1
      end

      after_perform do
        context.after_perform_3b = context.perform_3 + 1
      end

      def perform
        context.perform_3 = context.perform_2 + 1
      end
    end
  end

  let(:interactor_class) do
    build_organizer do
      organize TestInteractor1, TestInteractor2, TestInteractor3
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
    it { is_expected.to have_attributes(
      perform_1: 1, 
      perform_2: 2, 
      perform_3: 3, 
      after_perform_3b: 4,
      after_perform_3a: 5,
      after_perform_1b: 6,
      after_perform_1a: 7,
      after_perform_2: 8,
    ) }

    context 'when last interactor fails' do
      let!(:failing_interactor) do
        build_interactor('FailingInteractor') do
          def perform
            context.fail!
          end
        end
      end

      let(:interactor_class) do
        build_organizer do
          organize TestInteractor1, TestInteractor2, FailingInteractor
        end
      end

      subject { interactor_class.perform}

      it { is_expected.to have_attributes(
        perform_1: 1, 
        perform_2: 2, 
      )}

      it { is_expected.to_not respond_to(
        :after_perform_1a, 
        :after_perform_1b, 
      )}
    end

    context 'when after_perform in first interactor fails' do
      let!(:failing_interactor) do
        build_interactor('FailingInteractor') do
          defer_after_callbacks_when_organized

          after_perform do
            context.fail!
          end

          def perform
            context.perform_1 = 1
          end
        end
      end

      let(:interactor_class) do
        build_organizer do
          organize FailingInteractor, TestInteractor2, TestInteractor3
        end
      end

      subject { interactor_class.perform}

      it { is_expected.to have_attributes(
        perform_1: 1, 
        perform_2: 2, 
        perform_3: 3, 
        after_perform_3b: 4,
        after_perform_3a: 5,
      )}

      it { is_expected.to_not respond_to(
        :after_perform_1a, 
        :after_perform_1b, 
        :after_perform_2,
      )}
    end
  end
end
