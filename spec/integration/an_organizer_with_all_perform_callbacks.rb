# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with around all callbacks', type: :integration do
  let!(:test_interactor_1) do
    build_interactor('TestInteractor1') do
      before_perform do
        context.before_perform_1 = context.around_all_perform_start + 1
      end

      after_perform do
        context.after_perform_1 = context.around_perform_1_end + 1
      end

      around_perform :around
      def around
        context.around_perform_1_start = context.before_perform_1 + 1
        yield
        context.around_perform_1_end = context.perform_1 + 1
      end

      def perform
        context.perform_1 = context.around_perform_1_start + 1
      end
    end
  end

  let!(:test_interactor_2) do
    build_interactor('TestInteractor2') do
      defer_after_callbacks_when_organized

      before_perform do
        context.before_perform_2 = context.after_perform_1 + 1
      end

      after_perform do
        context.after_perform_2 = context.after_all_perform + 1
      end

      around_perform :around
      def around
        context.around_perform_2_start = context.before_perform_2 + 1
        yield
        context.around_perform_2_end = context.perform_2 + 1
      end

      def perform
        context.perform_2 = context.around_perform_2_start + 1
      end
    end
  end

  let(:interactor_class) do
    build_organizer do
      before_all_perform do
        context.before_all_perform = 1
      end

      after_all_perform do
        context.after_all_perform = context.around_all_perform_end + 1
      end

      around_all_perform :around_all
      def around_all
        context.around_all_perform_start = context.before_all_perform + 1
        yield
        context.around_all_perform_end = context.around_perform_2_end + 1
      end

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
    it { is_expected.to have_attributes(
      before_all_perform: 1,
      around_all_perform_start: 2,

      before_perform_1: 3,
      around_perform_1_start: 4,
      perform_1: 5, 
      around_perform_1_end: 6,
      after_perform_1: 7,

      before_perform_2: 8,
      around_perform_2_start: 9,
      perform_2: 10, 
      around_perform_2_end: 11,

      around_all_perform_end: 12,
      after_all_perform: 13,
      after_perform_2: 14,
    ) }
  end
end
