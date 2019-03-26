# frozen_string_literal: true

RSpec.shared_examples 'An ActiveInteractor::Context::Base class' do
  it { should respond_to :attributes }
  it { should respond_to :attributes= }

  ActiveModel::Validations::ClassMethods.instance_methods.each do |method|
    it { should respond_to method }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to method }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Context::Base instance' do
  it { should respond_to :rollback! }
  it { should respond_to :attributes }
  it { should respond_to :clean! }
  it { should respond_to :keys }
  it { should respond_to :called! }
  it { should respond_to :fail! }
  it { should respond_to :fail? }
  it { should respond_to :failure? }
  it { should respond_to :success? }
  it { should respond_to :successful? }

  ActiveModel::Validations.instance_methods.each do |method|
    it { should respond_to method }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to method }
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
