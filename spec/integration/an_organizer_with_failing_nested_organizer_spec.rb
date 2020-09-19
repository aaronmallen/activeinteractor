# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with failing nested organizer', type: :integration do
  let!(:parent_interactor1) { build_interactor('TestParentInteractor1') }
  let!(:parent_interactor2) { build_interactor('TestParentInteractor2') }
  let!(:child_interactor1) { build_interactor('TestChildInteractor1') }
  let!(:child_interactor2) do
    build_interactor('TestChildInteractor2') do
      def perform
        context.fail!
      end
    end
  end

  let!(:child_interactor_class) do
    build_organizer('TestChildOrganizer') do
      organize TestChildInteractor1, TestChildInteractor2
    end
  end

  let(:parent_interactor_class) do
    build_organizer('TestParentOrganizer') do
      organize TestParentInteractor1, TestChildOrganizer, TestParentInteractor2
    end
  end

  describe '.perform' do
    subject { parent_interactor_class.perform }

    before do
      expect_any_instance_of(child_interactor_class).to receive(:perform).and_call_original
      expect_any_instance_of(child_interactor1).to receive(:perform).and_call_original
      expect_any_instance_of(child_interactor2).to receive(:perform).and_call_original
      expect_any_instance_of(child_interactor2).to receive(:rollback).and_call_original
      expect_any_instance_of(child_interactor1).to receive(:rollback).and_call_original
      expect_any_instance_of(parent_interactor1).to receive(:rollback).and_call_original
      expect_any_instance_of(parent_interactor2).not_to receive(:perform).and_call_original
      expect_any_instance_of(parent_interactor2).not_to receive(:rollback).and_call_original
    end

    it { is_expected.to be_a parent_interactor_class.context_class }

    it { is_expected.to be_failure }
  end
end
