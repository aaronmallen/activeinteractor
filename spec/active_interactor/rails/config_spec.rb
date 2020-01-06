# frozen_string_literal: true

require 'spec_helper'
require 'active_interactor/rails'

RSpec.describe ActiveInteractor::Rails::Config do
  subject { described_class.new }

  it { is_expected.to respond_to :directory }
end
