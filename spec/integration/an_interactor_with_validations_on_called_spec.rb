# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with validations on :called', type: :integration do
  let(:interactor_class) do
    build_interactor do
      context_validates :test_field, presence: true, on: :called

      def perform
        context.test_field = 'test' if context.should_have_test_field
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform(context_attributes) }

    context 'with :should_have_test_field true' do
      let(:context_attributes) { { should_have_test_field: true } }

      it { is_expected.to be_an ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
    end

    context 'with :should_have_test_field false' do
      let(:context_attributes) { { should_have_test_field: false } }

      it { is_expected.to be_an ActiveInteractor::Interactor::Result }
      it { is_expected.to be_failure }
      it 'is expected to have errors on :some_field' do
        expect(subject.errors[:test_field]).not_to be_nil
      end
    end
  end
end
