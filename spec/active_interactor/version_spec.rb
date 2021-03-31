# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Version do
  describe '::MAJOR' do
    subject(:major) { described_class::MAJOR }

    it { is_expected.to be_an Integer }
  end

  describe '::MINOR' do
    subject(:minor) { described_class::MINOR }

    it { is_expected.to be_an Integer }
  end

  describe '::PATCH' do
    subject(:patch) { described_class::PATCH }

    it { is_expected.to be_an Integer }
  end

  describe '::PRE' do
    subject(:pre) { described_class::PRE }

    it 'is expected to be nil or String' do
      expect([NilClass, String]).to include pre.class
    end
  end

  describe '::META' do
    subject(:meta) { described_class::META }

    it 'is expected to be nil or String' do
      expect([NilClass, String]).to include meta.class
    end
  end

  describe '.gem_version' do
    subject(:gem_version) { described_class.gem_version }

    before do
      stub_const('ActiveInteractor::Version::MAJOR', major)
      stub_const('ActiveInteractor::Version::MINOR', minor)
      stub_const('ActiveInteractor::Version::PATCH', patch)
      stub_const('ActiveInteractor::Version::PRE', pre)
      stub_const('ActiveInteractor::Version::META', meta)
    end

    let(:major) { 0 }
    let(:minor) { 1 }
    let(:patch) { 0 }
    let(:pre) { 'beta.1' }
    let(:meta) { 'nightly.1234' }

    it { is_expected.to eq [major, minor, patch, pre, meta].join('.') }
  end

  describe '.semver' do
    subject(:semver) { described_class.semver }

    before do
      stub_const('ActiveInteractor::Version::MAJOR', major)
      stub_const('ActiveInteractor::Version::MINOR', minor)
      stub_const('ActiveInteractor::Version::PATCH', patch)
      stub_const('ActiveInteractor::Version::PRE', pre)
      stub_const('ActiveInteractor::Version::META', meta)
    end

    context 'when PRE and META are nil' do
      let(:major) { 0 }
      let(:minor) { 1 }
      let(:patch) { 0 }
      let(:pre) { nil }
      let(:meta) { nil }

      it { is_expected.to eq "#{major}.#{minor}.#{patch}" }
    end

    context 'when PRE is not nil and META is nil' do
      let(:major) { 0 }
      let(:minor) { 1 }
      let(:patch) { 0 }
      let(:pre) { 'beta.1' }
      let(:meta) { nil }

      it { is_expected.to eq "#{major}.#{minor}.#{patch}-#{pre}" }
    end

    context 'when PRE is not nil and META is not nil' do
      let(:major) { 0 }
      let(:minor) { 1 }
      let(:patch) { 0 }
      let(:pre) { 'beta.1' }
      let(:meta) { 'nightly.1234' }

      it { is_expected.to eq "#{major}.#{minor}.#{patch}-#{pre}+#{meta}" }
    end

    context 'when PRE is nil and META is not nil' do
      let(:major) { 0 }
      let(:minor) { 1 }
      let(:patch) { 0 }
      let(:pre) { nil }
      let(:meta) { 'nightly.1234' }

      it { is_expected.to eq "#{major}.#{minor}.#{patch}" }
    end
  end
end
