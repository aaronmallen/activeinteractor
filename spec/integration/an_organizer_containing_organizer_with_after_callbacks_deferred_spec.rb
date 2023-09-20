# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer containing an organizer with after callbacks deferred', type: :integration do
  let!(:test_interactor_1) do
    build_interactor('TestInteractor1') do
      defer_after_callbacks_when_organized

      after_perform do
        context.steps << 'after_perform_1a'
      end

      after_perform do
        context.steps << 'after_perform_1b'
      end

      def perform
        context.steps = []
        context.steps << 'perform_1'
      end
    end
  end

  let!(:test_interactor_2) do
    build_interactor('TestInteractor2') do
      after_perform do
        context.steps << 'after_perform_2'
      end

      def perform
        context.steps << 'perform_2'
      end
    end
  end

  let!(:test_interactor_3) do
    build_interactor('TestInteractor3') do
      defer_after_callbacks_when_organized

      after_perform do
        context.steps << 'after_perform_3a'
      end

      after_perform do
        context.steps << 'after_perform_3b'
      end

      def perform
        context.steps << 'perform_3'
      end
    end
  end

  let!(:test_interactor_4) do
    build_interactor('TestInteractor4') do
      after_perform do
        context.steps << 'after_perform_4a'
      end

      after_perform do
        context.steps << 'after_perform_4b'
      end

      def perform
        context.steps << 'perform_4'
      end
    end
  end

  let!(:test_sub_organizer_5) do
    build_organizer('TestSubOrganizer5') do
      defer_after_callbacks_when_organized

      after_perform do
        context.steps << 'after_perform_5a'
      end

      after_perform do
        context.steps << 'after_perform_5b'
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
      steps: [
        'perform_1',
        'perform_3',
        'perform_4', 
        'after_perform_4b',
        'after_perform_4a',
        'after_perform_3b',
        'after_perform_3a',
        'perform_2', 
        'after_perform_2',
        'after_perform_1b',
        'after_perform_1a',
        'after_perform_5b',
        'after_perform_5a',
      ]
    ) }
  end
end
