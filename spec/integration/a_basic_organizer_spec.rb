# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A basic organizer', type: :integration do
  let!(:test_interactor_1) do
    build_interactor('TestInteractor1') do
      def perform
        context.test_field_1 = 'test 1'
      end
    end
  end

  let!(:test_interactor_2) do
    build_interactor('TestInteractor2') do
      def perform
        context.test_field_2 = 'test 2'
      end
    end
  end

  let(:interactor_class) do
    build_organizer do
      organize TestInteractor1, TestInteractor2
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'
  include_examples 'a class with organizer callback methods'

  describe '.context_class' do
    subject { interactor_class.context_class }

    it { is_expected.to eq TestOrganizer::Context }
    it { is_expected.to be < ActiveInteractor::Context::Base }
  end

  describe '.perform' do
    subject { interactor_class.perform }

    it { is_expected.to be_a interactor_class.context_class }
    it { is_expected.to be_successful }
    it { is_expected.to have_attributes(test_field_1: 'test 1', test_field_2: 'test 2') }
  end

  context 'when the first interactor fails' do
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.fail!
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to receive #rollback on the first interactor' do
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
          .and_call_original
        subject
      end
      it 'is expected not to receive #perform! on the second interactor' do
        expect_any_instance_of(test_interactor_2).not_to receive(:perform!)
        subject
      end

      # https://github.com/aaronmallen/activeinteractor/issues/169
      context 'with error message "something went wrong"' do
        let!(:test_interactor_1) do
          build_interactor('TestInteractor1') do
            def perform
              context.fail!('something went wrong')
            end
          end
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_failure }
        it { expect(subject.errors.count).to eq 1 }
        it 'is expected to have errors "something went wrong" on :context' do
          expect(subject.errors[:context]).not_to be_empty
          expect(subject.errors[:context]).to include 'something went wrong'
        end
      end
    end
  end

  context 'when the second interactor fails' do
    let!(:test_interactor_2) do
      build_interactor('TestInteractor2') do
        def perform
          context.fail!
        end
      end
    end

    describe '.perform' do
      subject { interactor_class.perform }

      it { expect { subject }.not_to raise_error }
      it { is_expected.to be_a interactor_class.context_class }
      it { is_expected.to be_failure }
      it 'is expected to receive #rollback on all interactors' do
        expect_any_instance_of(test_interactor_2).to receive(:rollback)
        expect_any_instance_of(test_interactor_1).to receive(:rollback)
        subject
      end

      # https://github.com/aaronmallen/activeinteractor/issues/169
      context 'with error message "something went wrong"' do
        let!(:test_interactor_2) do
          build_interactor('TestInteractor2') do
            def perform
              context.fail!('something went wrong')
            end
          end
        end

        it { expect { subject }.not_to raise_error }
        it { is_expected.to be_a interactor_class.context_class }
        it { is_expected.to be_failure }
        it { expect(subject.errors.count).to eq 1 }
        it 'is expected to have errors "something went wrong" on :context' do
          expect(subject.errors[:context]).not_to be_empty
          expect(subject.errors[:context]).to include 'something went wrong'
        end
      end
    end
  end

  # https://github.com/aaronmallen/activeinteractor/issues/151
  context 'with an interactor class having a predefined context class with attributes [:foo]' do
    let!(:test_context_class) do
      build_context('TestInteractor1Context') do
        attributes :foo
        attributes :baz
      end
    end

    # rubocop:disable Metrics/AbcSize
    let!(:test_interactor_1) do
      build_interactor('TestInteractor1') do
        def perform
          context.has_foo_as_method = context.foo.present?
          context.has_foo_as_element = context[:foo].present?
          context.has_bar_as_method = context.bar.present?
          context.has_bar_as_element = context[:bar].present?
          context.baz = 'baz'
          context.has_baz_as_method = context.baz.present?
          context.has_baz_as_element = context[:baz].present?
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    let(:interactor_class) do
      build_organizer do
        organize :test_interactor_1
      end
    end

    context 'when passing a context argument { :foo => "foo", :bar => "bar" }' do
      let(:context_attributes) { { foo: 'foo', bar: 'bar' } }

      describe '.perform' do
        subject(:result) { interactor_class.perform(context_attributes) }
        it { is_expected.to have_attributes(foo: 'foo', bar: 'bar', baz: 'baz') }

        it 'is expected to copy all attributes in the contexts to each interactor' do
          expect(subject.has_foo_as_method).to be true
          expect(subject.has_foo_as_element).to be true
          expect(subject.has_bar_as_method).to be true
          expect(subject.has_bar_as_element).to be true
          expect(subject.has_baz_as_method).to be true
          expect(subject.has_baz_as_element).to be true
        end

        describe '#attributes' do
          subject { result.attributes }

          it { is_expected.to be_a Hash }
          it { is_expected.to be_empty }
        end
      end

      context 'with attributes [:foo] on the organizer context class' do
        let!(:interactor_class) do
          build_organizer do
            context_attributes :foo
            organize :test_interactor_1
          end
        end

        describe '.perform' do
          subject(:result) { interactor_class.perform(context_attributes) }
          it { is_expected.to have_attributes(foo: 'foo', bar: 'bar') }

          it 'is expected to copy all attributes in the contexts to each interactor' do
            expect(subject.has_foo_as_method).to be true
            expect(subject.has_foo_as_element).to be true
            expect(subject.has_bar_as_method).to be true
            expect(subject.has_bar_as_element).to be true
          end

          describe '#attributes' do
            subject { result.attributes }

            it { is_expected.to be_a Hash }
            it { is_expected.to eq(foo: 'foo') }
          end
        end
      end
    end
  end
end
