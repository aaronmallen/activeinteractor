# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An organizer with options callbacks', type: :integration do
  let!(:interactor1) do
    build_interactor('TestInteractor1') do
      def perform
        context.step = 3 if context.step == 2
        context.step = 6 if context.step == 5
      end
    end
  end

  let(:interactor_class) do
    build_organizer do
      organize do
        add TestInteractor1, before: :test_before_method, after: :test_after_method
        add TestInteractor1, before: lambda {
          context.step = 5 if context.step == 4
        }, after: lambda {
          context.step = 7 if context.step == 6
        }
      end

      private

      def test_before_method
        context.step = 2 if context.step == 1
      end

      def test_after_method
        context.step = 4 if context.step == 3
      end
    end
  end

  include_examples 'a class with interactor methods'
  include_examples 'a class with interactor callback methods'
  include_examples 'a class with interactor context methods'
  include_examples 'a class with organizer callback methods'

  describe '.perform' do
    subject { interactor_class.perform(step: 1) }

    it { is_expected.to be_a interactor_class.context_class }

    it 'is expected to receive #test_before_method once' do
      expect_any_instance_of(interactor_class).to receive(:test_before_method)
        .exactly(:once)
      subject
    end

    it 'is expected to receive #test_after_method once' do
      expect_any_instance_of(interactor_class).to receive(:test_after_method)
        .exactly(:once)
      subject
    end

    it 'runs callbacks in sequence' do
      expect(subject.step).to eq(7)
    end
  end
end
