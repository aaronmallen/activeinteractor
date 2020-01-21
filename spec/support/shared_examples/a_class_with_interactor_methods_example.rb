# frozen_string_literal: true

RSpec.shared_examples 'a class with interactor methods' do
  describe '.perform' do
    subject { interactor_class.perform }

    it 'is expected to receive #execute_perform on a new instance of ActiveInteractor::Interactor::Worker' do
      expect_any_instance_of(ActiveInteractor::Interactor::Worker).to receive(:execute_perform)
      subject
    end
  end

  describe '.perform!' do
    subject { interactor_class.perform! }

    it 'is expected to receive #execute_perform! on a new instance of ActiveInteractor::Interactor::Worker' do
      expect_any_instance_of(ActiveInteractor::Interactor::Worker).to receive(:execute_perform!)
      subject
    end
  end
end
