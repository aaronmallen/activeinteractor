# frozen_string_literal: true

RSpec.shared_examples 'A class that extends ActiveInteractor::Models' do
  it { expect(model_class).to respond_to :attribute }
  it { expect(model_class).to respond_to :attributes }

  describe 'as an instance' do
    subject { model_class.new }

    it { is_expected.to respond_to :attributes }
    it { is_expected.to respond_to :called! }
    it { is_expected.to respond_to :fail! }
    it { is_expected.to respond_to :fail? }
    it { is_expected.to respond_to :failure? }
    it { is_expected.to respond_to :merge! }
    it { is_expected.to respond_to :rollback! }
    it { is_expected.to respond_to :success? }
    it { is_expected.to respond_to :successful? }
  end

  describe '.new' do
    subject { model_class.new(attributes) }

    describe 'with arguments {:foo => "foo"}' do
      let(:attributes) { { foo: 'foo' } }

      it { is_expected.to have_attributes(foo: 'foo') }
    end

    describe 'with arguments {:bar => "bar"}' do
      let(:attributes) { model_class.new(bar: 'bar') }

      it { expect { subject }.to raise_error(ActiveModel::UnknownAttributeError) }
    end

    describe 'with arguments <#ModelClass foo="foo">' do
      let(:other_instance) { model_class.new(foo: 'foo') }
      let(:attributes) { other_instance }

      it { is_expected.to have_attributes(foo: 'foo') }

      context 'with argument instance having @_failed eq to true' do
        before { other_instance.instance_variable_set('@_failed', true) }

        it { is_expected.to be_failure }
      end

      context 'with argument instance having @_called eq to ["foo"]' do
        before { other_instance.instance_variable_set('@_called', %w[foo]) }

        it 'is expected to have instance variable @_called eq to ["foo"]' do
          expect(subject.instance_variable_get('@_called')).to eq %w[foo]
        end
      end

      context 'with argument instance having @_rolled_back eq to true' do
        before { other_instance.instance_variable_set('@_rolled_back', true) }

        it 'is expected to have instance variable @_rolled_back eq to true' do
          expect(subject.instance_variable_get('@_rolled_back')).to eq true
        end
      end
    end

    describe 'with arguments <#OtherClass bar="bar">' do
      let(:attributes) { model_class.new(other_instance) }
      let!(:other_class) do
        build_class('OtherClass') do
          extend ActiveInteractor::Models
          acts_as_context
          attribute :bar
        end
      end
      let(:other_instance) { other_class.new(bar: 'bar') }

      it { expect { subject }.to raise_error(ActiveModel::UnknownAttributeError) }
    end
  end
end
