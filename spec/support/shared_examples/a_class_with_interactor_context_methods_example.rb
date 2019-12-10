# frozen_string_literal: true

RSpec.shared_examples 'a class with interactor context methods' do
  describe '.context_attributes' do
    subject { interactor_class.context_attributes(attributes) }
    let(:attributes) { :some_attribute }

    it 'calls .attributes on .context_class' do
      expect(interactor_class.context_class).to receive(:attributes)
        .with(:some_attribute)
        .and_return(true)
      subject
    end
  end

  describe '#context_fail!' do
    subject { interactor_class.new.context_fail! }

    it 'calls #fail! on instance of .context_class' do
      expect_any_instance_of(interactor_class.context_class).to receive(:fail!)
        .and_return(true)
      subject
    end
  end

  describe '#context_rollback!' do
    subject { interactor_class.new.context_rollback! }

    it 'calls #rollback! on instance of .context_class' do
      expect_any_instance_of(interactor_class.context_class).to receive(:rollback!)
        .and_return(true)
      subject
    end
  end

  describe '#context_valid?' do
    subject { interactor_class.new.context_valid? }

    it 'calls #valid? on instance of .context_class' do
      expect_any_instance_of(interactor_class.context_class).to receive(:valid?)
        .and_return(true)
      subject
    end
  end

  describe '#finalize_context!' do
    subject { instance.finalize_context! }
    let(:instance) { interactor_class.new }

    it 'calls #called! on instance of .context_class' do
      expect_any_instance_of(interactor_class.context_class).to receive(:called!)
        .with(instance)
      subject
    end

    it { is_expected.to be_an interactor_class.context_class }
  end
end
