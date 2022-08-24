# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An interactor with deferred after callbacks', type: :integration do
  let!(:interactor_with_config) do
    build_interactor('InteractorWithConfig') do
      defer_after_callbacks_when_organized

      def perform
        context.test_field_1 = 'test'
      end
    end
  end

  let!(:interactor_without_config) do
    build_interactor('InteractorWithoutConfig') do

      def perform
        context.test_field_2 = 'test'
      end
    end
  end

  it 'is expected to have true for InteractorWithConfig#after_callbacks_deferred_when_organized' do
    expect(InteractorWithConfig).to have_attributes(after_callbacks_deferred_when_organized: true)
  end

  it 'is expected to have false for InteractorWithoutConfig#after_callbacks_deferred_when_organized' do
    expect(InteractorWithoutConfig).to have_attributes(after_callbacks_deferred_when_organized: false)
  end
end
