# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Version do
  describe '::MAJOR' do
    subject(:major) { described_class::MAJOR }

    it { is_expected.to be_a Integer }
  end

  describe '::MINOR' do
    subject(:minor) { described_class::MINOR }

    it { is_expected.to be_a Integer }
  end

  describe '::PATCH' do
    subject(:patch) { described_class::PATCH }

    it { is_expected.to be_a Integer }
  end

  describe '::PRE' do
    subject(:pre) { described_class::PRE }

    it 'is a String or Nil' do
      expect([String, NilClass]).to include pre.class
    end
  end

  describe '::META' do
    subject(:meta) { described_class::META }

    it 'is a String or Nil' do
      expect([String, NilClass]).to include meta.class
    end
  end

  describe '.gem_version' do
    subject(:gem_version) { described_class.gem_version }

    context 'when version is 1.0.0-beta.1+test' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', 'beta.1')
        stub_const('ActiveInteractor::Version::META', 'test')
      end

      it { is_expected.to eq '1.0.0.beta.1.test' }
    end

    context 'when version is 1.0.0+test' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', nil)
        stub_const('ActiveInteractor::Version::META', 'test')
      end

      it { is_expected.to eq '1.0.0' }
    end
  end

  describe '.semver' do
    subject(:semver) { described_class.semver }

    context 'when version is 1.0.0' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', nil)
        stub_const('ActiveInteractor::Version::META', nil)
      end

      it { is_expected.to eq '1.0.0' }
    end

    context 'when version is 1.0.0-beta.1' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', 'beta.1')
        stub_const('ActiveInteractor::Version::META', nil)
      end

      it { is_expected.to eq '1.0.0-beta.1' }
    end

    context 'when version is 1.0.0-beta.1+test' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', 'beta.1')
        stub_const('ActiveInteractor::Version::META', 'test')
      end

      it { is_expected.to eq '1.0.0-beta.1+test' }
    end

    context 'when version is 1.0.0+test' do
      before do
        stub_const('ActiveInteractor::Version::MAJOR', 1)
        stub_const('ActiveInteractor::Version::MINOR', 0)
        stub_const('ActiveInteractor::Version::PATCH', 0)
        stub_const('ActiveInteractor::Version::PRE', nil)
        stub_const('ActiveInteractor::Version::META', 'test')
      end

      it { is_expected.to eq '1.0.0+test' }
    end
  end
end
