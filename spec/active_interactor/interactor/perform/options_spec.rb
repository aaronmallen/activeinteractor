# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor::Perform::Options do
  subject { described_class.new }

  it { is_expected.to respond_to :organizer }
  it { is_expected.to respond_to :skip_each_perform_callbacks }
  it { is_expected.to respond_to :skip_perform_callbacks }
  it { is_expected.to respond_to :skip_rollback }
  it { is_expected.to respond_to :skip_rollback_callbacks }
  it { is_expected.to respond_to :validate }
  it { is_expected.to respond_to :validate_on_calling }
  it { is_expected.to respond_to :validate_on_called }

  describe 'defaults' do
    it { is_expected.to have_attributes(organizer: nil) }
    it { is_expected.to have_attributes(skip_each_perform_callbacks: false) }
    it { is_expected.to have_attributes(skip_perform_callbacks: false) }
    it { is_expected.to have_attributes(skip_rollback: false) }
    it { is_expected.to have_attributes(skip_rollback_callbacks: false) }
    it { is_expected.to have_attributes(validate: true) }
    it { is_expected.to have_attributes(validate_on_calling: true) }
    it { is_expected.to have_attributes(validate_on_called: true) }
  end
end
