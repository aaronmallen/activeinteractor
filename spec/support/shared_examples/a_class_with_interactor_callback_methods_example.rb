# frozen_string_literal: true

RSpec.shared_examples 'a class with interactor callback methods' do
  describe '.after_context_validation' do
    subject { interactor_class.after_context_validation(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :validation, :after, :some_method, { :prepend => true }' do
      expect(interactor_class).to receive(:set_callback)
        .with(:validation, :after, :some_method, prepend: true)
        .and_return(true)
      subject
    end
  end

  describe '.after_perform' do
    subject { interactor_class.after_perform(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :perform, :after, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:perform, :after, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.after_rollback' do
    subject { interactor_class.after_rollback(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :rollback, :after, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:rollback, :after, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.around_perform' do
    subject { interactor_class.around_perform(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :perform, :around, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:perform, :around, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.around_rollback' do
    subject { interactor_class.around_rollback(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :rollback, :around, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:rollback, :around, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.before_context_validation' do
    subject { interactor_class.before_context_validation(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :validation, :before, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:validation, :before, :some_method, {})
        .and_return(true)
      subject
    end
  end

  describe '.before_failure' do
    subject { interactor_class.before_failure(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :failure, :before, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:failure, :before, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.before_perform' do
    subject { interactor_class.before_perform(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :perform, :before, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:perform, :before, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.before_rollback' do
    subject { interactor_class.before_rollback(*args) }
    let(:args) { :some_method }

    it 'is expected to receive #set_callback with :rollback, :before, :some_method' do
      expect(interactor_class).to receive(:set_callback)
        .with(:rollback, :before, :some_method)
        .and_return(true)
      subject
    end
  end
end
