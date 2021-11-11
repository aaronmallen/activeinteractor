# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .around_perform callbacks', type: :integration do
  let(:interactor_class) do
    build_interactor do
      around_perform :test_around_perform

      def perform
        context.perform_step << 2
      end

      private

      def test_around_perform
        context.perform_step = []
        context.perform_step << 1
        yield
        context.perform_step << 3
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a interactor_class.context_class }
    it { is_expected.to have_attributes(perform_step: [1, 2, 3]) }
  end
end
