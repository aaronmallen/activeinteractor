# frozen_string_literal: true

RSpec.shared_examples 'A class that extends ActiveInteractor::Models' do
  it { expect(model_class).to respond_to :attribute }
  it { expect(model_class).to respond_to :attributes }

  describe 'as an instance' do
    subject { model_class.new }

    it { is_expected.to respond_to :attributes }
    it { is_expected.to respond_to :called! }
    it { is_expected.to respond_to :fail! }
    it { is_expected.to respond_to :fail? }
    it { is_expected.to respond_to :failure? }
    it { is_expected.to respond_to :merge! }
    it { is_expected.to respond_to :rollback! }
    it { is_expected.to respond_to :success? }
    it { is_expected.to respond_to :successful? }
  end
end
