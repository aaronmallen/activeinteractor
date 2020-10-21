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
        attributes :zoo
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
          context[:zoo] = 'zoo'
          context.has_zoo_as_method = context.zoo.present?
          context.has_zoo_as_element = context[:zoo].present?
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
        it { is_expected.to have_attributes(foo: 'foo', bar: 'bar', baz: 'baz', zoo: 'zoo') }

        it 'is expected to copy all attributes in the contexts to each interactor' do
          expect(subject.has_foo_as_method).to be true
          expect(subject.has_foo_as_element).to be true
          expect(subject.has_bar_as_method).to be true
          expect(subject.has_bar_as_element).to be true
          expect(subject.has_baz_as_method).to be true
          expect(subject.has_baz_as_element).to be true
          expect(subject.has_zoo_as_method).to be true
          expect(subject.has_zoo_as_element).to be true
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

    context 'when passing default attributes on the organizer and its interactors' do
      let!(:test_organizer_context_class) do
        build_context('TestOrganizerContext') do
          attribute :foo
          attribute :baz
          attribute :zoo, default: 'zoo'
        end
      end

      let!(:test_interactor_3_context_class) do
        build_context('TestInteractor3Context') do
          attribute :foo
          attribute :bar, default: 'bar'
          attribute :baz, default: 'baz'
          attribute :zoo
        end
      end

      let!(:test_interactor_4_context_class) do
        build_context('TestInteractor4Context') do
          attribute :foo
          attribute :bar, default: 'bar'
          attribute :baz
        end
      end

      let!(:test_interactor_3) do
        build_interactor('TestInteractor3') do
          def perform
            context.bar = 'bar'
            context.baz_is_set_at_3 = (context.baz == 'baz')
            context.zoo_is_set_at_3 = (context.zoo == 'zoo')
          end
        end
      end

      let!(:test_interactor_4) do
        build_interactor('TestInteractor4') do
          def perform
            context.baz_is_set_at_4 = (context.baz == 'baz')
            context.zoo_is_set_at_4 = (context.zoo == 'zoo')
          end
        end
      end

      let!(:interactor_class) do
        build_organizer('TestOrganizer') do
          organize TestInteractor3, TestInteractor4
        end
      end

      describe '.context_class' do
        describe 'TestOrganizer' do
          subject { interactor_class.context_class }

          it { is_expected.to eq TestOrganizerContext }
          it { is_expected.to be < ActiveInteractor::Context::Base }
        end

        describe 'TestInteractor3' do
          subject { test_interactor_3.context_class }

          it { is_expected.to eq TestInteractor3Context }
          it { is_expected.to be < ActiveInteractor::Context::Base }
        end

        describe 'TestInteractor4' do
          subject { test_interactor_4.context_class }

          it { is_expected.to eq TestInteractor4Context }
          it { is_expected.to be < ActiveInteractor::Context::Base }
        end
      end

      describe '.perform' do
        subject(:result) { interactor_class.perform(context_attributes) }

        context 'when inputs are not defined' do
          let(:context_attributes) { {} }

          it { is_expected.to have_attributes(foo: nil, bar: 'bar', baz: 'baz') }
        end

        context 'when [:foo] is defined' do
          let(:context_attributes) { { foo: 'foo' } }

          it { is_expected.to have_attributes(foo: 'foo', bar: 'bar', baz: 'baz') }
        end

        context 'when [:bar] is nil' do
          let(:context_attributes) { { bar: nil } }

          it { is_expected.to have_attributes(foo: nil, bar: 'bar', baz: 'baz') }
        end

        context 'when [:baz] is nil' do
          let(:context_attributes) { {} }

          it { is_expected.to have_attributes(baz: 'baz', baz_is_set_at_3: true, baz_is_set_at_4: true) }
        end

        context 'when [:zoo] is nil' do
          let(:context_attributes) { {} }

          it { is_expected.to have_attributes(zoo: 'zoo', zoo_is_set_at_3: true, zoo_is_set_at_4: true) }
        end
      end
    end
  end
end
