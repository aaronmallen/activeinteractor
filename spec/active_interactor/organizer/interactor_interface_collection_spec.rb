# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Organizer::InteractorInterfaceCollection do
  describe '#add' do
    subject { instance.add(interactor) }
    let(:instance) { described_class.new }

    context 'with an interactor that does not exist' do
      let(:interactor) { :an_interactor_that_does_not_exist }

      it { expect { subject }.not_to(change { instance.collection.count }) }
      it { is_expected.to be_a described_class }
    end

    context 'with an existing interactor' do
      before { build_interactor }

      context 'when interactors are passed as contants' do
        let(:interactor) { TestInteractor }

        it { expect { subject }.to change { instance.collection.count }.by(1) }
        it { is_expected.to be_a described_class }

        it 'is expected to add the appropriate interactor' do
          subject
          expect(instance.collection.first.interactor_class).to eq TestInteractor
        end
      end

      context 'when interactors are passed as symbols' do
        let(:interactor) { :test_interactor }

        it { expect { subject }.to change { instance.collection.count }.by(1) }
        it { is_expected.to be_a described_class }

        it 'is expected to add the appropriate interactor' do
          subject
          expect(instance.collection.first.interactor_class).to eq TestInteractor
        end
      end

      context 'when interactors are passed as strings' do
        let(:interactor) { 'TestInteractor' }

        it { expect { subject }.to change { instance.collection.count }.by(1) }
        it { is_expected.to be_a described_class }

        it 'is expected to add the appropriate interactor' do
          subject
          expect(instance.collection.first.interactor_class).to eq TestInteractor
        end
      end
    end
  end

  describe '#concat' do
    subject { instance.concat(interactors) }
    let(:instance) { described_class.new }

    context 'with two existing interactors' do
      let!(:interactor1) { build_interactor('TestInteractor1') }
      let!(:interactor2) { build_interactor('TestInteractor2') }
      let(:interactors) { %i[test_interactor_1 test_interactor_2] }

      it { expect { subject }.to change { instance.collection.count }.by(2) }

      it 'is expected to add the appropriate interactors' do
        subject
        expect(instance.collection.first.interactor_class).to eq TestInteractor1
        expect(instance.collection.last.interactor_class).to eq TestInteractor2
      end
    end
  end
end
