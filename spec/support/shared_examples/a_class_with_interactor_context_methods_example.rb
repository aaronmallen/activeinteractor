# frozen_string_literal: true

RSpec.shared_examples 'a class with interactor context methods' do
  describe '.context_attributes' do
    subject { interactor_class.context_attributes(attributes) }
    let(:attributes) { :some_attribute }

    it 'is expected to receive #attributes on .context_class with :some_attribute' do
      expect(interactor_class.context_class).to receive(:attributes)
        .with(:some_attribute)
        .and_return(true)
      subject
    end
  end

  describe '#context_fail!' do
    subject { interactor_class.new.context_fail! }

    it 'is expected to receive #fail! on instance of .context_class' do
      expect_any_instance_of(ActiveInteractor::Interactor::Result).to receive(:fail!)
        .and_return(true)
      subject
    end
  end

  describe '#context_rollback!' do
    subject { interactor_class.new.context_rollback! }

    it 'is expected to receive #rollback! on instance of .context_class' do
      expect_any_instance_of(ActiveInteractor::Interactor::Result).to receive(:rollback!)
        .and_return(true)
      subject
    end
  end

  describe '#context_valid?' do
    subject { interactor_class.new.context_valid? }

    it 'is expected to receive #valid? on instance of .context_class' do
      expect_any_instance_of(interactor_class.context_class).to receive(:valid?)
        .and_return(true)
      subject
    end
  end

  describe '#finalize_context!' do
    subject { instance.finalize_context! }
    let(:instance) { interactor_class.new }

    it 'is expected to receive #called! on instance of .context_class' do
      expect_any_instance_of(ActiveInteractor::Interactor::State).to receive(:called!)
        .with(instance)
      subject
    end

    it { is_expected.to be_an ActiveInteractor::Interactor::Result }
  end
end
