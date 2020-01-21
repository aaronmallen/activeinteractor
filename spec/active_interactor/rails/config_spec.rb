# frozen_string_literal: true

require 'spec_helper'
begin
  require 'active_interactor/rails'

  RSpec.describe ActiveInteractor::Rails::Config do
    subject { described_class.new }

    it { is_expected.to respond_to :directory }
    it { is_expected.to respond_to :generate_context_classes }

    describe '.defaults' do
      subject { described_class.defaults }

      it 'is expected to have attributes :directory => "interactors"' do
        expect(subject[:directory]).to eq 'interactors'
      end

      it 'is expected to have attributes :generate_context_classes => true' do
        expect(subject[:generate_context_classes]).to eq true
      end
    end
  end
rescue LoadError
  RSpec.describe 'ActiveInteractor::Rails::Config' do
    pending 'Rails not found skipping specs...'
  end
end
