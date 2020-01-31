# frozen_string_literal: true

require 'spec_helper'
begin
  require 'active_interactor/rails'
  require 'active_interactor/rails/orm/active_record'

  RSpec.describe 'ActiveRecord integration', type: :integration do
    let!(:active_record_base_mock) { build_class('ActiveRecordBaseMock') }

    context 'after ActiveSupport.run_load_hooks has been received with :active_record' do
      before { ActiveSupport.run_load_hooks(:active_record, active_record_base_mock) }

      describe 'an ActiveRecord model class with .acts_as_context' do
        let(:model_class) do
          build_class('ModelMock', active_record_base_mock) do
            acts_as_context
          end
        end

        include_examples 'A class that extends ActiveInteractor::Models'
      end
    end
  end
rescue LoadError
  RSpec.describe 'ActiveRecord Integration', type: :integration do
    pending 'Rails not found skipping specs...'
  end
end
