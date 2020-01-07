# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Config do
  subject { described_class.new }
  it { is_expected.to respond_to :logger }

  describe '.rails' do
    subject { described_class.new.rails }

    context 'with ::Rails not defined' do
      it { is_expected.to be_nil }
    end

    context 'with ::Rails defined' do
      before { stub_const('::Rails', 'Rails') }

      it { is_expected.not_to be_nil }
    end
  end
end
