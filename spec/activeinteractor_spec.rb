# frozen_string_literal: true

RSpec.describe ActiveInteractor do
  describe 'VERSION' do
    subject { described_class::VERSION }

    it { should_not be_nil }
  end
end
