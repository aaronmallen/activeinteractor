# frozen_string_literal: true

RSpec.describe ActiveInteractor::Configuration do
  let(:defaults) { described_class::DEFAULTS }

  describe '`::DEFAULTS`' do
    subject { described_class::DEFAULTS }

    it { should_not be_nil }
    it { should be_a Hash }
    it { should be_frozen }

    describe '`:logger`' do
      subject { described_class::DEFAULTS[:logger] }

      it { should_not be_nil }
      it { should be_a Logger }
    end
  end

  describe '`#new`' do
    subject { described_class.new(options) }
    after { reset_config_to_default! }

    context 'with no options' do
      let(:options) { nil }

      it 'should have the default options' do
        described_class::DEFAULTS.each do |option, value|
          expect(subject).to have_attributes(option => value)
        end
      end
    end

    context 'with unknown options' do
      let(:options) { { some_unknown_attr: 'unknown' } }

      it 'should ignore the unknown option' do
        expect(subject.instance_variable_get('@some_unknown_attr')).to be_nil
      end
    end

    context 'with valid options' do
      let(:options) do
        described_class::DEFAULTS.keys.each_with_object({}) do |option, options|
          options[option] = 'Test'
        end
      end

      it 'should assign the options to the configuration' do
        options.each_key do |option|
          expect(subject.send(option)).to eq 'Test'
        end
      end
    end
  end
end
