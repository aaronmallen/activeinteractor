# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor do
  describe '::VERSION' do
    subject { described_class::VERSION }

    it { is_expected.to be_a String }
  end

  describe '.config' do
    subject { described_class.config }

    it { is_expected.to be_a ActiveInteractor::Config }
  end

  describe '.configure' do
    it 'is expected to yield config' do
      expect { |b| described_class.configure(&b) }.to yield_control
    end
  end

  describe '.logger' do
    subject { described_class.logger }

    it { is_expected.to be_a Logger }
  end

  describe '::NextMajorDeprecator' do
    subject { described_class::NextMajorDeprecator }
    it { is_expected.to be_a ActiveSupport::Deprecation }
    it { is_expected.to have_attributes(deprecation_horizon: '2.0') }
  end
end
