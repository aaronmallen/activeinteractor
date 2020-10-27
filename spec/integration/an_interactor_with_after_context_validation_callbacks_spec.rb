# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with .after_context_validation callbacks', type: :integration do
  let(:interactor_class) do
    build_interactor do
      context_validates :test_field, presence: true
      after_context_validation :downcase_test_field

      private

      def downcase_test_field
        context.test_field = context.test_field.downcase
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.perform' do
    subject { interactor_class.perform(context_attributes) }

    context 'with valid context attributes' do
      let(:context_attributes) { { test_field: 'TEST' } }

      it { is_expected.to be_a ActiveInteractor::Interactor::Result }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field: 'test') }
    end
  end

  context 'having a condition on #after_context_valdation' do
    let(:interactor_class) do
      build_interactor do
        context_validates :test_field, presence: true
        after_context_validation :downcase_test_field, if: -> { context.should_downcase }

        private

        def downcase_test_field
          context.test_field = context.test_field.downcase
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform(context_attributes) }

      context 'with :test_field "TEST" and :should_downcase true' do
        let(:context_attributes) { { test_field: 'TEST', should_downcase: true } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'test') }
      end

      context 'with :test_field "TEST" and :should_downcase false' do
        let(:context_attributes) { { test_field: 'TEST', should_downcase: false } }

        it { is_expected.to be_a ActiveInteractor::Interactor::Result }
        it { is_expected.to be_successful }
        it { is_expected.to have_attributes(test_field: 'TEST') }
      end
    end
  end
end
