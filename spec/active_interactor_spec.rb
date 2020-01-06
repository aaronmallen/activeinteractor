# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor do
  describe '::VERSION' do
    subject { described_class::VERSION }

    it { is_expected.to be_a String }
  end

  describe '.logger' do
    subject { described_class.logger }

    it { is_expected.to be_a Logger }
  end

  describe '.logger=' do
    subject { described_class.logger = logger }
    let!(:original_logger) { described_class.logger }
    let(:logger) { double(:logger) }
    after { described_class.logger = original_logger }

    it { expect { subject }.to change { described_class.logger }.to(logger) }
  end
end
