# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Result do
  describe '#context' do
    subject { described_class.new(interactor).context }

    context 'with an instance of TestInteractor' do
      let(:interactor_class) { build_interactor }
      let(:interactor) { interactor_class.new }

      it { is_expected.to be_a interactor_class.context_class }
    end
  end

  describe '#resolve' do
    subject { described_class.new(interactor).resolve }

    context 'with an instance of TestInteractor' do
      let(:interactor_class) do
        build_interactor do
          context_attributes :test
          context_validates :test, presence: true
        end
      end

      context 'with a valid context instance' do
        let(:interactor) { interactor_class.new(test: 'test') }

        it 'is expected not to have errors' do
          expect(subject.errors).to be_empty
        end

        it 'is expected to have #state be successful' do
          expect(subject.state).to be_successful
        end

        it 'is expected to be #called on #state' do
          expect(subject.state.called).to include interactor
        end

        context 'with failed #state with "Test Error"' do
          before { interactor.state.fail!('Test Error') }

          it 'is expected to have #state be failure' do
            expect(subject.state).to be_failure
          end

          it 'is expected to have state errors' do
            expect(subject.errors).not_to be_empty
            expect(subject.errors[:interaction]).to include 'Test Error'
          end
        end
      end

      context 'with an invalid context instance' do
        let(:interactor) { interactor_class.new }

        it 'is expected to have context errors' do
          expect(subject.errors).not_to be_empty
          expect(subject.errors[:test]).to include "can't be blank"
        end

        it 'is expected to have #state be failure' do
          expect(subject.state).to be_failure
        end

        it 'is expected to be #called on #state' do
          expect(subject.state.called).to include interactor
        end

        context 'with failed #state with "Test Error"' do
          before { interactor.state.fail!('Test Error') }

          it 'is expected to have context errors' do
            expect(subject.errors).not_to be_empty
            expect(subject.errors[:test]).to include "can't be blank"
          end

          it 'is expected to have state errors' do
            expect(subject.errors).not_to be_empty
            expect(subject.errors[:interaction]).to include 'Test Error'
          end
        end
      end
    end
  end

  describe '#state' do
    subject { described_class.new(interactor).state }

    context 'with an instance of TestInteractor' do
      let(:interactor_class) { build_interactor }
      let(:interactor) { interactor_class.new }

      it { is_expected.to be_a ActiveInteractor::State }
    end
  end
end
