# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A failing interactor', type: :integration do
  let(:interactor_class) do
    build_interactor do
      def perform
        context.fail!
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

    it { expect { subject }.not_to raise_error }
    it { is_expected.to be_a ActiveInteractor::Interactor::Result }
    it { is_expected.to be_failure }
    it 'is expected to receive #rollback' do
      expect_any_instance_of(interactor_class).to receive(:rollback)
      subject
    end
  end

  describe '.perform!' do
    subject { interactor_class.perform! }

    it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }
  end
end
