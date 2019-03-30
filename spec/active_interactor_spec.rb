# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor do
  describe '`::VERSION`' do
    subject { described_class::VERSION }

    it { should_not be_nil }
    it { should be_a String }
  end

  describe '`#configuration`' do
    subject { described_class.configuration }

    it { should_not be_nil }
    it { should be_a ActiveInteractor::Configuration }
  end

  describe '`#configure`' do
    after { reset_config_to_default! }
    let(:options) do
      ActiveInteractor::Configuration::DEFAULTS.keys.each_with_object({}) do |option, options|
        options[option] = 'Test'
      end
    end

    it 'should configure ActiveInteractor' do
      described_class.configure do |config|
        options.each do |option, value|
          config.send("#{option}=".to_sym, value)
        end
      end
      options.each_key do |option|
        expect(ActiveInteractor.configuration.send(option.to_sym)).to eq 'Test'
      end
    end
  end

  describe '`#logger`' do
    subject { described_class.logger }

    it { should_not be_nil }
    it { should be_a Logger }
  end
end
