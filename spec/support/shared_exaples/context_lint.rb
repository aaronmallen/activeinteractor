# frozen_string_literal: true

RSpec.shared_examples 'An ActiveInteractor::Context::Base class' do
  include_examples 'An ActiveInteractor::Context::Base class respond_to'
  include_examples 'An ActiveInteractor::Context::Base class ClassMethods'
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base instance' do
  include_examples 'An ActiveInteractor::Context::Base instance respond_to'
  include_examples 'An ActiveInteractor::Context::Base instance methods'
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base class respond_to' do
  it { should respond_to :attributes }
  it { should respond_to :attributes= }

  ActiveModel::Validations::ClassMethods.instance_methods.each do |method|
    it { should respond_to method }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to method }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base class ClassMethods' do
  describe '`#attributes`' do
    context 'with no attributes defined' do
      it { expect(subject.attributes).to be_empty }

      context 'with validation callbacks defined for `:foo`' do
        before { subject.validates(:foo, presence: true) }
        it { expect(subject.attributes).to eq %i[foo] }
      end
    end

    context 'with attributes `:foo`, `:bar`, `:baz`' do
      before { subject.attributes = :foo, :bar, :baz }
      it { expect(subject.attributes).to eq %i[foo bar baz] }
    end
  end

  describe '`#attributes=`' do
    context 'with unique values `:foo`, `:bar`, `:baz`' do
      before { subject.attributes = :foo, :bar, :baz }
      it { expect(subject.attributes).to eq %i[foo bar baz] }
    end

    context 'with unique values `:foo`, `:foo` `:bar`, `:baz`' do
      before { subject.attributes = :foo, :foo, :bar, :baz }
      it { expect(subject.attributes).to eq %i[foo bar baz] }
    end
  end
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base instance respond_to' do
  it { should respond_to :attributes }
  it { should respond_to :called! }
  it { should respond_to :clean! }
  it { should respond_to :fail! }
  it { should respond_to :fail? }
  it { should respond_to :failure? }
  it { should respond_to :keys }
  it { should respond_to :rollback! }
  it { should respond_to :success? }
  it { should respond_to :successful? }

  ActiveModel::Validations.instance_methods.each do |method|
    it { should respond_to method }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to method }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base instance methods' do
  describe '`#called!`' do
    it 'should mark the interactor as called' do
      subject.called!
      expect(subject.send(:_called)).to include subject.send(:interactor)
    end
  end
end

RSpec.shared_examples 'A successful context' do
  it { should be_a_success }
end

RSpec.shared_examples 'A failed context' do
  it { should be_a_failure }
end

RSpec.shared_examples 'A valid context' do
  it { should be_valid }

  describe '`.errors`' do
    it { expect(subject.errors).to be_empty }
  end
end

RSpec.shared_examples 'An invalid context' do
  it { should be_invalid }

  describe '`.errors`' do
    it { expect(subject.errors).not_to be_empty }
  end
end
