# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Config do
  subject { described_class.new }
  it { is_expected.to respond_to :logger }
end
