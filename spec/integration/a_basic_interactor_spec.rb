# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A Basic Interactor' do
  let(:interactor) { build_interactor('TestInteractor') }
  subject { interactor }

  include_examples 'An ActiveInteractor::Base class'

  describe '`#perform`' do
    subject { interactor.perform }
    it { should be_an interactor.context_class }

    it 'invokes #perform on the instance' do
      expect_any_instance_of(interactor).to receive(:perform).exactly(:once)
      subject
    end

    include_examples 'A successful context'
    include_examples 'A valid context'
  end
end
