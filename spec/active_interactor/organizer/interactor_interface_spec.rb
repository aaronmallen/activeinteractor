# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Organizer::InteractorInterface do
  describe '.new' do
    subject(:instance) { described_class.new(interactor_class, options) }

    context 'with an interactor that does not exist' do
      let(:interactor_class) { :an_interactor_that_does_not_exist }
      let(:options) { {} }

      describe '#interactor_class' do
        subject { instance.interactor_class }

        it { is_expected.to be_nil }
      end
    end

    RSpec.shared_examples 'an instance of InteractorInterface correctly parse options' do
      context 'with options {:if => :some_method }' do
        let(:options) { { if: :some_method } }

        describe '#filters' do
          subject { instance.filters }

          it { is_expected.to eq(if: :some_method) }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:if => -> { context.test == true } }' do
        let(:options) { { if: -> { context.test == true } } }

        describe '#filters' do
          subject { instance.filters }

          it { expect(subject[:if]).not_to be_nil }
          it { expect(subject[:if]).to be_a Proc }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:unless => :some_method }' do
        let(:options) { { unless: :some_method } }

        describe '#filters' do
          subject { instance.filters }

          it { is_expected.to eq(unless: :some_method) }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:unless => -> { context.test == true } }' do
        let(:options) { { unless: -> { context.test == true } } }

        describe '#filters' do
          subject { instance.filters }

          it { expect(subject[:unless]).not_to be_nil }
          it { expect(subject[:unless]).to be_a Proc }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:before => :some_method }' do
        let(:options) { { before: :some_method } }

        describe '#callbacks' do
          subject { instance.callbacks }

          it { is_expected.to eq(before: :some_method) }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:before => -> { context.test = true } }' do
        let(:options) { { before: -> { context.test = true } } }

        describe '#callbacks' do
          subject { instance.callbacks }

          it { expect(subject[:before]).not_to be_nil }
          it { expect(subject[:before]).to be_a Proc }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:after => :some_method }' do
        let(:options) { { after: :some_method } }

        describe '#callbacks' do
          subject { instance.callbacks }

          it { is_expected.to eq(after: :some_method) }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options {:after => -> { context.test = true } }' do
        let(:options) { { after: -> { context.test = true } } }

        describe '#callbacks' do
          subject { instance.callbacks }

          it { expect(subject[:after]).not_to be_nil }
          it { expect(subject[:after]).to be_a Proc }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to be_empty }
        end
      end

      context 'with options { :validate => false }' do
        let(:options) { { validate: false } }

        describe '#filters' do
          subject { instance.filters }

          it { is_expected.to be_empty }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to eq(validate: false) }
        end
      end

      context 'with options { :if => :some_method, :validate => false, :before => :other_method }' do
        let(:options) { { if: :some_method, validate: false, before: :other_method } }

        describe '#filters' do
          subject { instance.filters }

          it { is_expected.to eq(if: :some_method) }
        end

        describe '#callbacks' do
          subject { instance.callbacks }

          it { is_expected.to eq(before: :other_method) }
        end

        describe '#perform_options' do
          subject { instance.perform_options }

          it { is_expected.to eq(validate: false) }
        end
      end
    end

    context 'with an existing interactor' do
      before { build_interactor }

      context 'when interactors are passed as contants' do
        let(:interactor_class) { TestInteractor }
        let(:options) { {} }

        include_examples 'an instance of InteractorInterface correctly parse options'

        describe '#interactor_class' do
          subject { instance.interactor_class }

          it { is_expected.to eq TestInteractor }
        end
      end

      context 'when interactors are passed as symbols' do
        let(:interactor_class) { :test_interactor }
        let(:options) { {} }

        include_examples 'an instance of InteractorInterface correctly parse options'

        describe '#interactor_class' do
          subject { instance.interactor_class }

          it { is_expected.to eq TestInteractor }
        end
      end

      context 'when interactors are passed as strings' do
        let(:interactor_class) { 'TestInteractor' }
        let(:options) { {} }

        include_examples 'an instance of InteractorInterface correctly parse options'

        describe '#interactor_class' do
          subject { instance.interactor_class }

          it { is_expected.to eq TestInteractor }
        end
      end
    end
  end
end
