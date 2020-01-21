# frozen_string_literal: true

require 'spec_helper'
begin
  require 'active_interactor/rails'

  RSpec.describe ActiveInteractor::Rails do
    describe '.config' do
      subject { described_class.config }

      it { is_expected.to be_a ActiveInteractor::Rails::Config }
    end

    describe '.configure' do
      it 'is expected to yield config' do
        expect { |b| described_class.configure(&b) }.to yield_control
      end
    end
  end
rescue LoadError
  RSpec.describe 'ActiveInteractor::Rails' do
    pending 'Rails not found skipping specs...'
  end
end
