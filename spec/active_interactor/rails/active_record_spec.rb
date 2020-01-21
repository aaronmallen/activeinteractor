# frozen_string_literal: true

require 'spec_helper'
begin
  require 'active_interactor/rails'

  RSpec.describe ActiveInteractor::Rails::ActiveRecord do
    describe '.include_helpers' do
      subject { described_class.include_helpers }
      let!(:active_record_mock) { build_class('ActiveRecordBaseMock') }

      it 'is expected to extend ClassMethods' do
        subject
        ActiveSupport.run_load_hooks(:active_record_base, active_record_mock)
        expect(active_record_mock).to respond_to :acts_as_context
      end
    end
  end
rescue LoadError
  RSpec.describe 'ActiveInteractor::Rails::ActiveRecord' do
    pending 'Rails not found skipping specs...'
  end
end
