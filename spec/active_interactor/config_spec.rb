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
end
