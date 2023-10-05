# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with deferred after callbacks', type: :integration do
  let!(:deferred_interactor) do
    build_interactor('DeferredInteractor') do
      defer_after_callbacks_when_organized

      after_perform do
        context.steps << 'after_perform'
      end

      around_perform :around_perform
      def around_perform
        context.steps = []
        context.steps << 'around_perform_start'
        yield
        context.steps << 'around_perform_end'
      end

      def perform
        context.steps << 'perform'
      end
    end
  end

  let!(:nondeferred_interactor) do
    build_interactor('NondeferredInteractor') do
      after_perform do
        context.steps << 'after_perform'
      end

      around_perform :around_perform
      def around_perform
        context.steps = []
        context.steps << 'around_perform_start'
        yield
        context.steps << 'around_perform_end'
      end

      def perform
        context.steps << 'perform'
      end
    end
  end

  it 'is expected to have true for InteractorWithConfig#after_callbacks_deferred_when_organized' do
    expect(DeferredInteractor).to have_attributes(after_callbacks_deferred_when_organized: true)
  end

  it 'is expected to have false for InteractorWithoutConfig#after_callbacks_deferred_when_organized' do
    expect(NondeferredInteractor).to have_attributes(after_callbacks_deferred_when_organized: false)
  end

  it 'does not change the order for a single interactor' do
    deferred_result = deferred_interactor.perform
    nondeferred_result = nondeferred_interactor.perform

    expect(deferred_result.steps).to eq(nondeferred_result.steps)
  end
end