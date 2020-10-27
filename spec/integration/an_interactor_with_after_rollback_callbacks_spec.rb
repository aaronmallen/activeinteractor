# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .after_rollback callbacks', type: :integration do
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

    it { is_expected.to be_a ActiveInteractor::Interactor::Result }
    it 'is expected to receive #test_after_rollback' do
      expect_any_instance_of(interactor_class).to receive(:test_after_rollback)
      subject
    end
  end
end
