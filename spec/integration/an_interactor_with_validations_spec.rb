# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with validations', type: :integration do
  let(:interactor_class) do
    build_interactor do
      context_validates :test_field, presence: true

      def perform
        context.other_field = context.test_field
      end

      def rollback
        context.other_field = 'failed'
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform(context_attributes) }

    context 'with valid context attributes' do
      let(:context_attributes) { { test_field: 'test' } }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field: 'test', other_field: 'test') }
    end

    context 'with invalid context attributes' do
      let(:context_attributes) { {} }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it { is_expected.to have_attributes(other_field: 'failed') }

      it 'is expected to have errors on :test_field' do
        expect(subject.errors[:test_field]).not_to be_nil
      end
    end
  end

  context 'having conditional validations' do
    let(:interactor_class) do
      build_interactor do
        context_validates :test_field, presence: true, if: :test_condition

        def perform
          context.other_field = context.test_field
        end

        def rollback
          context.other_field = 'failed'
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with :test_field defined and :test_condition false' do
        let(:context_attributes) { { test_field: 'test', test_condition: false } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'test', test_condition: false, other_field: 'test') }
      end

      context 'with :test_field defined and :test_condition true' do
        let(:context_attributes) { { test_field: 'test', test_condition: true } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'test', test_condition: true, other_field: 'test') }
      end

      context 'with :test_field undefined and :test_condition true' do
        let(:context_attributes) { { test_condition: true } }

        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_failure }
        it { is_expected.to have_attributes(test_condition: true, other_field: 'failed') }

        it 'is expected to have errors on :test_field' do
          expect(subject.errors[:test_field]).not_to be_nil
        end
      end
    end
  end
end
