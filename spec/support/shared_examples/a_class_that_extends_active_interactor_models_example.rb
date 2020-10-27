# frozen_string_literal: true

RSpec.shared_examples 'A class that extends ActiveInteractor::Models' do
  it { expect(model_class).to respond_to :attribute }
  it { expect(model_class).to respond_to :attributes }

  describe 'as an instance' do
    subject { model_class.new }

    it { is_expected.to respond_to :attributes }
    it { is_expected.to respond_to :merge! }
  end

  describe '.new' do
    subject { model_class.new(attributes) }

    describe 'with arguments {:foo => "foo"}' do
      let(:attributes) { { foo: 'foo' } }

      it { is_expected.to have_attributes(foo: 'foo') }
    end

    describe 'with arguments {:bar => "bar"}' do
      let(:attributes) { model_class.new(bar: 'bar') }
    end

    describe 'with arguments <#ModelClass foo="foo">' do
      let(:other_instance) { model_class.new(foo: 'foo') }
      let(:attributes) { other_instance.attributes }

      it { is_expected.to have_attributes(foo: 'foo') }
    end

    describe 'with arguments <#OtherClass bar="bar">' do
      let(:attributes) { model_class.new(other_instance.attributes) }
      let!(:other_class) do
        build_class('OtherClass') do
          include ActiveModel::Attributes
          include ActiveModel::Model
          extend ActiveInteractor::Models
          acts_as_context
          attribute :bar
        end
      end
      let(:other_instance) { other_class.new(bar: 'bar') }
    end
  end
end
