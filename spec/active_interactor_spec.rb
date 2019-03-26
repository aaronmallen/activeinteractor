# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor do
  describe 'VERSION' do
    subject { described_class::VERSION }

    it { should_not be_nil }
  end

  describe '`.configuration`' do
    subject { described_class.configuration }

    it { should_not be_nil }
    it { should be_a ActiveInteractor::Configuration }
  end
end
