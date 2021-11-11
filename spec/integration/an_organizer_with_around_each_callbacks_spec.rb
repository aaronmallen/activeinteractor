# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with .around_each callbacks', type: :integration do
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
