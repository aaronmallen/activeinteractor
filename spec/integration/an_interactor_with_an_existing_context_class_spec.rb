# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with an existing .context_class', type: :integration do
  context 'having .name "AnInteractor"' do
    let(:interactor_class) { build_interactor('AnInteractor') }

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    context 'having a class named "AnInteractorContext" with validations' do
      let!(:context_class) do
        build_context('AnInteractorContext') do
          validates :test_field, presence: true
        end
      end

      describe '.context_class' do
        subject { interactor_class.context_class }

        it { is_expected.to eq AnInteractorContext }
        it { is_expected.to be < ActiveInteractor::Context::Base }
      end

      describe '.perform' do
        subject { interactor_class.perform(context_attributes) }

        context 'with valid context attributes' do
          let(:context_attributes) { { test_field: 'test' } }

          it { is_expected.to be_an AnInteractorContext }
          it { is_expected.to be_successful }
        end

        context 'with invalid context attributes' do
          let(:context_attributes) { {} }

          it { is_expected.to be_an AnInteractorContext }
          it { is_expected.to be_failure }

          it 'is expected to have errors on :some_field' do
            expect(subject.errors[:test_field]).not_to be_nil
          end
        end
      end
    end
  end
end
