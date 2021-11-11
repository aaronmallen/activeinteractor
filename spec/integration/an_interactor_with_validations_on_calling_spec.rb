# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with validations on :calling', type: :integration do
  let(:interactor_class) do
    build_interactor do
      context_validates :test_field, presence: true, on: :calling
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform(context_attributes) }

    context 'with :test_field "test"' do
      let(:context_attributes) { { test_field: 'test' } }

      it { is_expected.to be_an TestInteractor::Context }
      it { is_expected.to be_successful }
    end

    context 'with :test_field nil' do
      let(:context_attributes) { {} }

      it { is_expected.to be_an TestInteractor::Context }
      it { is_expected.to be_failure }

      it 'is expected to have errors on :some_field' do
        expect(subject.errors[:test_field]).not_to be_nil
      end
    end
  end
end
