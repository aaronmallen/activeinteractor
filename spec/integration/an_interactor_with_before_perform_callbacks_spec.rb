# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .before_perform callbacks', type: :integration do
  let(:interactor_class) do
    build_interactor do
      before_perform :test_before_perform

      private

      def test_before_perform; end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a ActiveInteractor::Interactor::Result }
    it { is_expected.to be_successful }
    it 'is expected to receive #test_before_perform' do
      expect_any_instance_of(interactor_class).to receive(:test_before_perform)
      subject
    end
  end
end
