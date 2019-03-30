# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context::Base do
  describe "A class that inherits #{described_class} called \"TestContext\"" do
    subject(:context) { build_context('TestContext') }
    include_examples 'An ActiveInteractor::Context::Base class'

    context 'with an interactor instance' do
      let(:interactor) { build_interactor.new }
      subject { context.new(interactor, attributes) }

      context "an instance of #{described_class}" do
        subject(:context) { interactor.class.context_class.new(interactor, attributes) }

        context 'with `nil` attributes' do
          let(:attributes) { nil }

          describe '`#attributes`' do
            subject { context.attributes }
            it { should be_a Hash }
            it { should be_empty }
          end

          describe '`#clean!`' do
            subject { context.clean! }
            it { should be_a Hash }
            it { should be_empty }
          end
        end
      end
    end
  end
end
