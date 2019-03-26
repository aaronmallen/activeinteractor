# frozen_string_literal: true

require 'active_model/validations'
require 'active_support/core_ext/string/inflections'

RSpec.shared_examples 'An ActiveInteractor::Base class' do
  it { should respond_to :after_context_validation }
  it { should respond_to :after_perform }
  it { should respond_to :after_rollback }
  it { should respond_to :allow_context_to_be_invalid }
  it { should respond_to :around_perform }
  it { should respond_to :around_rollback }
  it { should respond_to :before_context_validation }
  it { should respond_to :before_perform }
  it { should respond_to :before_rollback }
  it { should respond_to :clean_context_on_completion }
  it { should respond_to :context_attributes }
  it { should respond_to :context_class }
  it { should respond_to :perform }
  it { should respond_to :perform! }

  ActiveModel::Validations::ClassMethods.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end

  describe '`#context_class`' do
    it { expect(subject.context_class).not_to be_nil }
    it { expect(subject.context_class).to eq "#{subject.name}::Context".safe_constantize }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Base instance' do
  it { should respond_to :call_perform }
  it { should respond_to :call_perform! }
  it { should respond_to :call_rollback }
  it { should respond_to :perform }
  it { should respond_to :rollback }
  it { should respond_to :fail_on_invalid_context! }
  it { should respond_to :validate_context }
  it { should respond_to :context }

  ActiveModel::Validations.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end

  describe '`.context`' do
    it { expect(subject.context).to be_a ActiveInteractor::Context::Base }
    it { expect(subject.context).to be_a "#{instance.class.name}::Context".safe_constantize }
  end
end
