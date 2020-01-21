# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .before_rollback callbacks', type: :integration do
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
    it 'is expected to receive #test_before_rollback' do
      expect_any_instance_of(interactor_class).to receive(:test_before_rollback)
      subject
    end
  end
end
