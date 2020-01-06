# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Base do
  let(:interactor_class) { described_class }
  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'

  describe '.contextualize_with' do
    subject { described_class.contextualize_with(klass) }

    context 'with an class that does not exist' do
      let(:klass) { 'SomeClassThatDoesNotExist' }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::InvalidContextClass) }
    end

    context 'with context class TestContext' do
      before { build_context }

      context 'when passed as a string' do
        let(:klass) { 'TestContext' }

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a symbol' do
        let(:klass) { :test_context }

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end

      context 'when passed as a constant' do
        let(:klass) { TestContext }

        it 'assigns the context class' do
          subject
          expect(described_class.context_class).to eq TestContext
        end
      end
    end
  end
end
