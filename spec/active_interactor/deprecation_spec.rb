# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Deprecation do
  before do
    stub_const('ActiveInteractor::Deprecation::TEST_DEPRECATOR_1', deprecator1)
    stub_const('ActiveInteractor::Deprecation::TEST_DEPRECATOR_2', deprecator2)

    stub_const('ActiveInteractor::Deprecation::V2', nil)
  end

  let(:deprecator1) { ActiveSupport::Deprecation.new('test1', 'ActiveInteractor') }
  let(:deprecator2) { ActiveSupport::Deprecation.new('test2', 'ActiveInteractor') }

  describe '.disable_debugging!' do
    subject(:disable_debugging!) { described_class.disable_debugging! }

    it 'is expected to disable debugging on all deprecators' do
      deprecator1.debug = true
      deprecator2.debug = true
      disable_debugging!

      expect(deprecator1.debug).to eq false
      expect(deprecator2.debug).to eq false
    end
  end

  describe '.disable_logging!' do
    subject(:disable_logging!) { described_class.disable_logging! }

    it 'is expected to disable logging on all deprecators' do
      deprecator1.silenced = false
      deprecator2.silenced = false
      disable_logging!

      expect(deprecator1.silenced).to eq true
      expect(deprecator2.silenced).to eq true
    end
  end

  describe '.enable_debugging!' do
    subject(:enable_debugging!) { described_class.enable_debugging! }

    it 'is expected to enable debugging on all deprecators' do
      deprecator1.debug = false
      deprecator2.debug = false
      enable_debugging!

      expect(deprecator1.debug).to eq true
      expect(deprecator2.debug).to eq true
    end
  end

  describe '.enable_logging!' do
    subject(:enable_logging!) { described_class.enable_logging! }

    it 'is expected to enable logging on all deprecators' do
      deprecator1.silenced = true
      deprecator2.silenced = true
      enable_logging!

      expect(deprecator1.silenced).to eq false
      expect(deprecator2.silenced).to eq false
    end
  end
end
