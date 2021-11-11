# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer performing in parallel', type: :integration do
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
      perform_in_parallel
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
end
