# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Base do
  describe "A class that inherits #{described_class} called \"TestInteractor\"" do
    subject(:interactor) { build_interactor('TestInteractor') }
    include_examples 'An ActiveInteractor::Base class'

    describe 'as an instance' do
      subject { interactor.new(context) }

      context 'with a `nil` context' do
        let(:context) { nil }
        include_examples 'An ActiveInteractor::Base instance'
      end

      context 'with an empty context' do
        let(:context) { {} }
        include_examples 'An ActiveInteractor::Base instance'
      end

      context 'with a context having key values' do
        let(:context) { { test: 'test' } }
        include_examples 'An ActiveInteractor::Base instance'
      end
    end
  end
end
