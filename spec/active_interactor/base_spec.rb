# frozen_string_literal: true

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
    end
  end
end
