# frozen_string_literal: true

RSpec.shared_examples 'a class with organizer callback methods' do
  describe '.after_each_perform' do
    subject { interactor_class.after_each_perform(*args) }
    let(:args) { :some_method }

    it 'sets after each_perform callback' do
      expect(interactor_class).to receive(:set_callback)
        .with(:each_perform, :after, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.around_each_perform' do
    subject { interactor_class.around_each_perform(*args) }
    let(:args) { :some_method }

    it 'sets around each_perform callback' do
      expect(interactor_class).to receive(:set_callback)
        .with(:each_perform, :around, :some_method)
        .and_return(true)
      subject
    end
  end

  describe '.before_each_perform' do
    subject { interactor_class.before_each_perform(*args) }
    let(:args) { :some_method }

    it 'sets before each_perform callback' do
      expect(interactor_class).to receive(:set_callback)
        .with(:each_perform, :before, :some_method)
        .and_return(true)
      subject
    end
  end
end
