# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Config do
  subject { described_class.new }
  it { is_expected.to respond_to :logger }

  describe '.defaults' do
    subject { described_class.defaults }

    it 'is expected to have attributes :logger => Logger.new' do
      expect(subject[:logger]).to be_a Logger
    end
  end

  describe '#silence_deprecation_warnings' do
    subject { described_class.new.silence_deprecation_warnings }
    let(:next_major_mock) { ActiveSupport::Deprecation.new('1.0', 'ActiveInteractorTest') }
    before { stub_const('ActiveInteractor::NextMajorDeprecator', next_major_mock) }

    it { expect { subject }.to change { next_major_mock.silenced }.to(true) }
  end
end
