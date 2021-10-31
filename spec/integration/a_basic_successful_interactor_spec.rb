# frozen_string_literal: true

RSpec.describe 'A Basic Successful Interactor' do
  let(:interactor) do
    build_interactor('ABasicSuccessfulInteractor') do
      def interact
        output.name = input.name
      end
    end
  end

  describe '.perform' do
    subject(:perform) { interactor.perform(name: name) }

    let(:name) { 'test' }

    xit { is_expected.to be_successful }

    xit 'returns a result with the expected name' do
      expect(perform.context.name).to eq name
    end
  end
end
