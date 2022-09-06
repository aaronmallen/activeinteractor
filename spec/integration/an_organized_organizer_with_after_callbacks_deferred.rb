# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organized organizer with after callbacks deferred', type: :integration do
  let!(:test_interactor_1) do
    build_interactor('TestInteractor1') do
      defer_after_callbacks_when_organized

      after_perform do
        context.after_perform_1a = context.after_perform_1b + 1
      end

      after_perform do
        context.after_perform_1b = context.after_perform_2 + 1 
      end

      def perform
        context.perform_1 = 1
      end
    end
  end

  let!(:test_interactor_2) do
    build_interactor('TestInteractor2') do
      after_perform do
        context.after_perform_2 = context.perform_2 + 1
      end

      def perform
        context.perform_2 = context.after_perform_3a + 1
      end
    end
  end

  let!(:test_interactor_3) do
    build_interactor('TestInteractor3') do
      defer_after_callbacks_when_organized

      after_perform do
        context.after_perform_3a = context.after_perform_3b + 1
      end

      after_perform do
        context.after_perform_3b = context.after_perform_4a + 1
      end

      def perform
        context.perform_3 = context.perform_1 + 1
      end
    end
  end

  let!(:test_interactor_4) do
    build_interactor('TestInteractor4') do
      after_perform do
        context.after_perform_4a = context.after_perform_4b + 1
      end

      after_perform do
        context.after_perform_4b = context.perform_4 + 1
      end

      def perform
        context.perform_4 = context.perform_3 + 1
      end
    end
  end

  let!(:test_sub_organizer_5) do
    build_organizer('TestSubOrganizer5') do
      defer_after_callbacks_when_organized

      after_perform do
        context.after_perform_5a = context.after_perform_5b + 1
      end

      after_perform do
        context.after_perform_5b = context.after_perform_1a + 1
      end

      organize TestInteractor3, TestInteractor4
    end
  end

  let(:interactor_class) do
    build_organizer do
      organize TestInteractor1, TestSubOrganizer5, TestInteractor2
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
      perform_3: 2,
      perform_4: 3, 
      after_perform_4b: 4,
      after_perform_4a: 5,
      after_perform_3b: 6,
      after_perform_3a: 7,
      perform_2: 8, 
      after_perform_2: 9,
      after_perform_1b: 10,
      after_perform_1a: 11,
      after_perform_5b: 12,
      after_perform_5a: 13,
    ) }
  end
end
