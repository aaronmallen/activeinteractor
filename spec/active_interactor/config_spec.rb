# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Config do
  subject { described_class.new }

  it { is_expected.to respond_to :deprecation_debugging }
  it { is_expected.to respond_to :logger }
  it { is_expected.to respond_to :silence_deprecation_warnings }

  describe '.defaults' do
    subject(:defaults) { described_class.defaults }

    it 'is expected to have attributes :deprecation_debugging => false' do
      expect(defaults[:deprecation_debugging]).to eq false
    end

    it 'is expected to have attributes :logger => Logger.new' do
      expect(defaults[:logger]).to be_a Logger
    end

    it 'is expected to have attributes :silence_deprecation_warnings => false' do
      expect(defaults[:silence_deprecation_warnings]).to eq false
    end
  end
end
