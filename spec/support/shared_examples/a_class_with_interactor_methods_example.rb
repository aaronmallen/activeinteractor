# frozen_string_literal: true

RSpec.shared_examples 'a class with interactor methods' do
  describe '.perform' do
    subject { interactor_class.perform }

    it 'calls #execute_perform on a new instance' do
      expect_any_instance_of(interactor_class).to receive(:execute_perform)
      subject
    end
  end

  describe '.perform!' do
    subject { interactor_class.perform! }

    it 'calls #execute_perform! on a new instance' do
      expect_any_instance_of(interactor_class).to receive(:execute_perform!)
      subject
    end
  end
end
