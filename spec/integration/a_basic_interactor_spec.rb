# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A basic interactor', type: :integration do
  let(:interactor_class) do
    build_interactor do
      def perform
        context.test_field = 'test'
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.context_class' do
    subject { interactor_class.context_class }

    it { is_expected.to eq TestInteractor::Context }
    it { is_expected.to be < ActiveInteractor::Context::Base }
  end

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a interactor_class.context_class }
    it { is_expected.to be_successful }
    it { is_expected.to have_attributes(test_field: 'test') }
  end

  describe '.perform!' do
    subject { interactor_class.perform! }

    it { expect { subject }.not_to raise_error }
    it { is_expected.to be_a interactor_class.context_class }
    it { is_expected.to be_successful }
    it { is_expected.to have_attributes(test_field: 'test') }
  end

  context 'having #context_attributes :test_field' do
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

  context 'having a .name "AnInteractor"' do
    let(:interactor_class) { build_interactor('AnInteractor') }

    context 'having a class defined named "AnInteractorContext"' do
      let!(:context_class) { build_context('AnInteractorContext') }

      describe '.context_class' do
        subject { interactor_class.context_class }

        it { is_expected.to eq AnInteractorContext }
        it { is_expected.to be < ActiveInteractor::Context::Base }
      end
    end
  end

  context 'with a context class named "ATestContext"' do
    let!(:context_class) { build_context('ATestContext') }

    context 'with .contextualize_with :a_test_context' do
      let(:interactor_class) do
        build_interactor do
          contextualize_with :a_test_context
        end
      end

      describe '.context_class' do
        subject { interactor_class.context_class }

        it { is_expected.to eq ATestContext }
        it { is_expected.to be < ActiveInteractor::Context::Base }
      end
    end
  end
end
