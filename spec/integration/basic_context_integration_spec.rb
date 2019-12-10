# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Basic Context Integration', type: :integration do
  describe 'An interactor with context attributes' do
    let(:interactor_class) do
      build_interactor do
        context_attributes :test_field

        def perform
          context.test_field = 'test'
          context.some_other_field = 'test 2'
        end
      end
    end

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.perform' do
      subject(:result) { interactor_class.perform }

      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_successful }
      it { is_expected.to have_attributes(test_field: 'test', some_other_field: 'test 2') }

      describe '.attributes' do
        subject { result.attributes }

        it { is_expected.to eq(test_field: 'test') }
      end
    end
  end

  describe 'An interactor with a defined context class named "AnInteractor"' do
    let(:interactor_class) { build_interactor('AnInteractor') }
    let!(:context_class) { build_context('AnInteractorContext') }

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.context_class' do
      subject { interactor_class.context_class }

      it { is_expected.to eq AnInteractorContext }
      it { is_expected.to be < ActiveInteractor::Context::Base }
    end
  end

  describe 'An interactor contextualized with ATestContext' do
    let(:interactor_class) do
      build_interactor do
        contextualize_with :a_test_context
      end
    end

    let!(:context_class) { build_context('ATestContext') }

    include_examples 'a class with interactor methods'
    include_examples 'a class with interactor callback methods'
    include_examples 'a class with interactor context methods'

    describe '.context_class' do
      subject { interactor_class.context_class }

      it { is_expected.to eq ATestContext }
      it { is_expected.to be < ActiveInteractor::Context::Base }
    end
  end
end
