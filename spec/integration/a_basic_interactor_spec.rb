# frozen_string_literal: true

RSpec.describe 'A Basic Interactor', type: %i[integration interactor] do
  let(:interactor) do
    build_interactor('ABasicInteractor') do
      argument :name, String, 'A name'
      returns :name, String, 'A name'

      def resolve
        output.name = input.name
      end
    end
  end

  describe '.perform' do
    subject(:perform) { interactor.perform(name: name) }

    context 'when given valid input arguments' do
      let(:name) { 'test' }

      xit { is_expected.to be_a ActiveInteractor::Result }
      xit { is_expected.to be_successful }

      xit 'returns a valid context with expected attributes' do
        context = perform.context

        expect(context.valid?).to eq true
        expect(context.name).to eq name
        expect(context[:name]).to eq name
      end
    end

    context 'when given invalid input arguments' do
      let(:name) { 1 }

      xit { is_expected.to be_a ActiveInteractor::Result }
      xit { is_expected.to be_failure }

      xit 'returns an invalid context with expected attributes' do
        context = perform.context

        expect(context.valid?).to eq false
        expect(context.name).to eq name
        expect(context[:name]).to eq name
      end

      xit 'returns an ActiveModel::Errors instance with expected errors' do
        errors = perform.errors

        expect(errors[:name]).not_to be_nil
        expect(errors[:name].full_messages).to include 'Name must be a String'
      end
    end
  end
end
