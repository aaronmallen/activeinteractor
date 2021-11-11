# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Error::ContextFailure do
  subject { described_class.new }

  it { is_expected.to respond_to :context }

  context 'when context is equal to nil' do
    subject { described_class.new(nil) }

    it { is_expected.to have_attributes(message: 'Context failed!') }
  end

  context 'when context is an instance of "TestContext"' do
    subject { described_class.new(TestContext.new) }

    before { build_context }

    it { is_expected.to have_attributes(message: 'TestContext failed!') }

    it 'is expected to have an instance of TestContext' do
      expect(subject.context).to be_a TestContext
    end
  end
end

RSpec.describe ActiveInteractor::Error::InvalidContextClass do
  subject { described_class.new }

  it { is_expected.to respond_to :class_name }

  context 'when class_name is equal to nil' do
    subject { described_class.new(nil) }

    it { is_expected.to have_attributes(message: 'invalid context class ') }
  end

  context 'when class_name is equal to "MyContect"' do
    subject { described_class.new('MyContext') }

    it { is_expected.to have_attributes(message: 'invalid context class MyContext') }
  end
end
