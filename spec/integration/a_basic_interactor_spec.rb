# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A Basic Interactor' do
  let(:interactor) { build_interactor('TestInteractor') }
  subject { interactor }

  include_examples 'An ActiveInteractor::Base class'

  describe '`#perform`' do
    subject { interactor.perform }
    it { should be_an interactor.context_class }
    include_examples 'A successful context'
    include_examples 'A valid context'
  end
end
