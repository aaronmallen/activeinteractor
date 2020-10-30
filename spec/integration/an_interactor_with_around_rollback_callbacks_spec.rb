# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .around_rollback callbacks', type: :integration do
  let(:interactor_class) do
    build_interactor do
      around_rollback :test_around_rollback

      def perform
        context.fail!
      end

      def rollback
        context.rollback_step << 2
      end

      private

      def test_around_rollback
        context.rollback_step = []
        context.rollback_step << 1
        yield
        context.rollback_step << 3
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a ActiveInteractor::Interactor::Result }
    it { is_expected.to have_attributes(rollback_step: [1, 2, 3]) }
  end
end
