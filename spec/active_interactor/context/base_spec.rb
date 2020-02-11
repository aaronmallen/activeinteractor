# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context::Base do
  describe '.attributes' do
    context 'when no arguments are passed' do
      subject { context_class.attributes }
      let!(:context_class) { build_context }
      it { is_expected.to eq [] }

      context 'when an attribute :foo was previously defined' do
        let!(:context_class) do
          build_context do
            attributes :foo
          end
        end

        it { is_expected.to eq %i[foo] }
      end
    end

    context 'when given arguments :foo and :bar' do
      subject { context_class.attributes(:foo, :bar) }
      let!(:context_class) { build_context }

      it { is_expected.to eq %i[bar foo] }

      context 'when an attribute :foo was previously defined' do
        before { TestContext.attributes(:foo) }

        it { is_expected.to eq %i[bar foo] }
      end
    end
  end

  describe '#attribute?' do
    subject { instance.attribute?(attribute) }

    context 'with class attributes []' do
      let(:instance) { build_context.new }
      let(:attribute) { :foo }

      it { is_expected.to eq false }
    end

    context 'with class attributes [:foo]' do
      let!(:context_class) do
        build_context do
          attributes :foo
        end
      end
      let(:instance) { context_class.new }

      context 'checking attribute :foo' do
        let(:attribute) { :foo }

        it { is_expected.to eq true }
      end

      context 'checking attribute :bar' do
        let(:attribute) { :bar }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#attributes' do
    subject { instance.attributes }

    context 'with class attributes []' do
      context 'with an instance having attributes { :foo => "foo", :bar => "bar", :baz => "baz" }' do
        let(:instance) { described_class.new(foo: 'foo', bar: 'bar', baz: 'baz') }

        it { is_expected.to be_a Hash }
        it { is_expected.to be_empty }
      end
    end

    context 'with class attributes [:foo, :bar, :baz]' do
      before { build_context.attributes(:foo, :bar) }

      context 'with an instance having attributes { :foo => "foo", :bar => "bar" }' do
        let(:instance) { TestContext.new(foo: 'foo', bar: 'bar') }

        it { is_expected.to be_a Hash }
        it { is_expected.to eq(bar: 'bar', foo: 'foo') }
      end

      context 'with an instance having attributes { :foo => "foo", :bar => "bar", :baz => "baz" }' do
        let(:instance) { TestContext.new(foo: 'foo', bar: 'bar', baz: 'baz') }

        it { is_expected.to be_a Hash }
        it { is_expected.to eq(bar: 'bar', foo: 'foo') }
        it 'is expected to assign :baz' do
          expect(instance.baz).to eq 'baz'
        end
      end
    end
  end

  describe '#called!' do
    subject do
      instance.called!(interactor1)
      instance.called!(interactor2)
    end

    let(:instance) { described_class.new }
    let(:interactor1) { double(:interactor1) }
    let(:interactor2) { double(:interactor2) }

    it 'is expected to append interactors to instance variable _called' do
      expect { subject }.to change { instance.send(:_called) }
        .from([])
        .to([interactor1, interactor2])
    end
  end

  describe '#fail!' do
    subject { instance.fail!(errors) }
    let(:instance) { described_class.new }

    context 'with errors equal to nil' do
      let(:errors) { nil }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }

      it 'is expected not to merge errors' do
        expect(instance.errors).not_to receive(:merge!).with(nil)
        subject
      rescue ActiveInteractor::Error::ContextFailure # rubocop:disable Lint/SuppressedException
      end

      it 'is expected to be a failure' do
        subject
      rescue ActiveInteractor::Error::ContextFailure
        expect(instance).to be_a_failure
      end
    end

    context 'with errors from another instance on the attribute :foo' do
      let(:errors) { instance2.errors }
      let(:instance2) { described_class.new }

      before { instance2.errors.add(:foo, 'foo') }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }

      it 'is expected to merge errors' do
        subject
      rescue ActiveInteractor::Error::ContextFailure
        expect(instance.errors[:foo]).to eq instance2.errors[:foo]
      end

      it 'is expected to be a failure' do
        subject
      rescue ActiveInteractor::Error::ContextFailure
        expect(instance).to be_a_failure
      end
    end

    context 'with errors "foo"' do
      let(:errors) { 'foo' }

      it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }

      it 'is expected to have error on :context equal to "foo"' do
        subject
      rescue ActiveInteractor::Error::ContextFailure
        expect(instance.errors[:context]).to include 'foo'
      end

      it 'is expected to be a failure' do
        subject
      rescue ActiveInteractor::Error::ContextFailure
        expect(instance).to be_a_failure
      end
    end
  end

  describe '#failure?' do
    subject { instance.failure? }
    let(:instance) { described_class.new }

    it { is_expected.to eq false }

    context 'when context has failed' do
      before { instance.instance_variable_set('@_failed', true) }

      it { is_expected.to eq true }
    end
  end

  describe '#merge' do
    subject { instance.merge!(attributes) }

    context 'with an instance having attributes { :foo => "foo"}' do
      let(:instance) { described_class.new(foo: 'foo') }

      context 'with a hash having attributes { :bar => "bar"}' do
        let(:attributes) { { bar: 'bar' } }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foo', bar: 'bar') }
      end

      context 'with a hash having attributes { :foo => "foobar"}' do
        let(:attributes) { { foo: 'foobar' } }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foobar') }
      end

      context 'with a previous instance having attributes { :bar => "bar" }' do
        let(:attributes) { described_class.new(bar: 'bar') }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foo', bar: 'bar') }

        context 'having errors on :foo' do
          before { attributes.errors.add(:foo, 'invalid') }

          it 'is expected to have errors on :foo' do
            expect(subject.errors[:foo]).not_to be_nil
            expect(subject.errors[:foo]).to include 'invalid'
          end
        end

        context 'having instance variable @_failed equal to true' do
          before { attributes.instance_variable_set('@_failed', true) }

          it { is_expected.to be_a described_class }
          it { is_expected.to have_attributes(foo: 'foo') }
          it 'is expected to preserve @_failed instance variable' do
            expect(subject.instance_variable_get('@_failed')).to eq true
          end
        end

        context 'having instance variable @_rolled_back equal to true' do
          before { attributes.instance_variable_set('@_rolled_back', true) }

          it { is_expected.to be_a described_class }
          it { is_expected.to have_attributes(foo: 'foo') }
          it 'is expected to preserve @_rolled_back instance variable' do
            expect(subject.instance_variable_get('@_rolled_back')).to eq true
          end
        end
      end

      context 'with a previous instance having attributes { :foo => "foobar"}' do
        let(:attributes) { described_class.new(foo: 'foobar') }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foobar') }
      end

      context 'having errors on :foo' do
        before { instance.errors.add(:foo, 'invalid') }

        context 'with a previous instance having attributes { :bar => "bar" }' do
          let(:attributes) { described_class.new(bar: 'bar') }

          it 'is expected to have errors on :foo' do
            expect(subject.errors[:foo]).not_to be_nil
            expect(subject.errors[:foo]).to include 'invalid'
          end

          context 'having errors on :bar' do
            before { attributes.errors.add(:bar, 'invalid') }

            it 'is expected to have errors on :foo' do
              expect(subject.errors[:foo]).not_to be_nil
              expect(subject.errors[:foo]).to include 'invalid'
            end

            it 'is expected to have errors on :bar' do
              expect(subject.errors[:bar]).not_to be_nil
              expect(subject.errors[:bar]).to include 'invalid'
            end
          end
        end
      end
    end
  end

  describe '#new' do
    subject { described_class.new(attributes) }

    context 'with a hash having attributes { :foo => "foo"}' do
      let(:attributes) { { foo: 'foo' } }

      it { is_expected.to be_a described_class }
      it { is_expected.to have_attributes(foo: 'foo') }
    end

    context 'with a previous instance having attributes { :foo => "foo" }' do
      let(:attributes) { described_class.new(foo: 'foo') }

      it { is_expected.to be_a described_class }
      it { is_expected.to have_attributes(foo: 'foo') }

      context 'having errors on :foo' do
        before { attributes.errors.add(:foo, 'invalid') }

        it { is_expected.to be_a described_class }
        it 'is expected to have errors on :foo' do
          expect(subject.errors[:foo]).not_to be_nil
          expect(subject.errors[:foo]).to include 'invalid'
        end
      end

      context 'having instance variable @_called equal to ["foo"]' do
        before { attributes.instance_variable_set('@_called', %w[foo]) }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foo') }
        it 'is expected to preserve @_called instance variable' do
          expect(subject.instance_variable_get('@_called')).to eq %w[foo]
        end
      end

      context 'having instance variable @_failed equal to true' do
        before { attributes.instance_variable_set('@_failed', true) }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foo') }
        it 'is expected to preserve @_failed instance variable' do
          expect(subject.instance_variable_get('@_failed')).to eq true
        end
      end

      context 'having instance variable @_rolled_back equal to true' do
        before { attributes.instance_variable_set('@_rolled_back', true) }

        it { is_expected.to be_a described_class }
        it { is_expected.to have_attributes(foo: 'foo') }
        it 'is expected to preserve @_rolled_back instance variable' do
          expect(subject.instance_variable_get('@_rolled_back')).to eq true
        end
      end
    end
  end

  describe '#rollback!' do
    subject { instance.rollback! }
    let(:instance) { described_class.new }

    context 'with #called! interactors' do
      let(:interactor1) { double(:interactor1) }
      let(:interactor2) { double(:interactor2) }

      before do
        allow(instance).to receive(:_called).and_return([interactor1, interactor2])
      end

      it 'is expected to rollback each interactor in reverse order' do
        expect(interactor2).to receive(:rollback).once.with(no_args).ordered
        expect(interactor1).to receive(:rollback).once.with(no_args).ordered
        subject
      end

      it 'is expected to ignore subsequent attempts' do
        expect(interactor2).to receive(:rollback).once
        expect(interactor1).to receive(:rollback).once
        subject
        subject
      end
    end
  end

  describe '#success?' do
    subject { instance.success? }
    let(:instance) { described_class.new }

    it { is_expected.to eq true }

    context 'when context has failed' do
      before { instance.instance_variable_set('@_failed', true) }

      it { is_expected.to eq false }
    end
  end
end
