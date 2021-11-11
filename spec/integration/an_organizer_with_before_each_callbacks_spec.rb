# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with .before_each callbacks', type: :integration do
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

    it 'is expected to receive #test_before_each_perform twice' do
      expect_any_instance_of(interactor_class).to receive(:test_before_each_perform)
        .exactly(:twice)
      subject
    end
  end
end
