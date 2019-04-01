# frozen_string_literal: true

require 'active_model/validations'
require 'active_support/core_ext/string/inflections'

RSpec.shared_examples 'An ActiveInteractor::Base class' do
  include_examples 'An ActiveInteractor::Base class respond_to'
  include_examples 'An ActiveInteractor::Base class attributes'
  include_examples 'An ActiveInteractor::Base class ClassMethods'
end

RSpec.shared_examples 'An ActiveInteractor::Base instance' do
  include_examples 'An ActiveInteractor::Base instance respond_to'
  include_examples 'An ActiveInteractor::Base instance methods'
end

RSpec.shared_examples 'An ActiveInteractor::Base class respond_to' do
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
end

RSpec.shared_examples 'An ActiveInteractor::Base class attributes' do
  describe '`.__clean_after_perform`' do
    it { expect(subject.__clean_after_perform).to eq false }
  end

  describe '`.__fail_on_invalid_context`' do
    it { expect(subject.__fail_on_invalid_context).to eq true }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Base class ClassMethods' do
  describe '`#after_context_validation`' do
    include_examples(
      'An ActiveInteractor::Base callback method',
      :after_context_validation,
      :validation,
      :after,
      prepend: true
    )

    context 'with `:on` option' do
      it 'should `#set_callback` with `:on` option' do
        expect(subject).to receive(:set_callback)
          .with(:validation, :after, :test_method, if: [], on: %i[calling], prepend: true)
        subject.after_context_validation :test_method, on: :calling
      end
    end
  end

  describe '`#after_perform`' do
    include_examples 'An ActiveInteractor::Base callback method', :after_perform, :perform, :after
  end

  describe '`#after_rollback`' do
    include_examples 'An ActiveInteractor::Base callback method', :after_rollback, :rollback, :after
  end

  describe '`#allow_context_to_be_invalid`' do
    describe '`.__clean_after_perform`' do
      it { expect(subject.__clean_after_perform).to eq false }
    end

    it 'should flag `.__fail_on_invalid_context` as `false`' do
      expect(subject).to receive(:__fail_on_invalid_context=).with(false).and_call_original
      subject.allow_context_to_be_invalid
      expect(subject.__fail_on_invalid_context).to eq false
    end
  end

  describe '`#around_perform`' do
    include_examples 'An ActiveInteractor::Base callback method', :around_perform, :perform, :around
  end

  describe '`#around_rollback`' do
    include_examples 'An ActiveInteractor::Base callback method', :around_rollback, :rollback, :around
  end

  describe '`#before_context_validation`' do
    include_examples 'An ActiveInteractor::Base callback method', :before_context_validation, :validation, :before, {}

    context 'with `:on` option' do
      it 'should `#set_callback` with `:on` option' do
        expect(subject).to receive(:set_callback)
          .with(:validation, :before, :test_method, if: [], on: %i[calling])
        subject.before_context_validation :test_method, on: :calling
      end
    end
  end

  describe '`#before_perform`' do
    include_examples 'An ActiveInteractor::Base callback method', :before_perform, :perform, :before
  end

  describe '`#before_rollback`' do
    include_examples 'An ActiveInteractor::Base callback method', :before_rollback, :rollback, :before
  end

  describe '`#clean_context_on_completion`' do
    it 'should flag `.__clean_after_perform` as `true`' do
      expect(subject).to receive(:__clean_after_perform=).with(true).and_call_original
      subject.clean_context_on_completion
      expect(subject.__clean_after_perform).to eq true
    end
  end

  describe '`#context_attributes`' do
    context 'with attributes `:foo`, `:bar`, `:baz`' do
      it 'should assign the attributes' do
        expect(subject.context_class).to receive(:attributes=)
          .with(%i[foo bar baz])
          .and_call_original
        subject.context_attributes :foo, :bar, :baz
        expect(subject.context_class.attributes).to eq %i[foo bar baz]
      end
    end
  end

  describe '`#context_class`' do
    it { expect(subject.context_class).not_to be_nil }
    it { expect(subject.context_class).to eq "#{subject.name}::Context".safe_constantize }
  end

  describe '`#perform`' do
    include_examples 'An ActiveInteractor::Base class perform', :perform
  end

  describe '`#perform!`' do
    include_examples 'An ActiveInteractor::Base class perform', :perform!
  end
end

RSpec.shared_examples 'An ActiveInteractor::Base class perform' do |method|
  it 'should create a new instance' do
    expect(subject).to receive(:new).with({}).and_call_original
    subject.send(method)
  end

  it "should invoke `#execute_#{method}` on the instance" do
    expect_any_instance_of(subject).to receive("execute_#{method}".to_sym).and_call_original
    subject.send(method)
  end

  it { expect(subject.send(method)).to be_a ActiveInteractor::Context::Base }
  it { expect(subject.send(method)).to be_a "#{subject.name}::Context".safe_constantize }
end

RSpec.shared_examples 'An ActiveInteractor::Base callback method' do |method, callback, type, *args|
  it 'should `#set_callback` with Symbol method' do
    dup_args = args.dup.prepend :test_method
    expect(subject).to receive(:set_callback)
      .with(callback, type, *dup_args)
    subject.send(method, :test_method)
  end

  it 'should `#set_callback` with lambda' do
    lambda_arg = -> { 'test' }
    dup_args = args.dup.prepend lambda_arg
    expect(subject).to receive(:set_callback)
      .with(callback, type, *dup_args)
    subject.send(method, lambda_arg)
  end

  it 'should `#set_callback` with conditionals' do
    dup_args = args.dup.prepend :test_method
    if dup_args.last.is_a?(Hash)
      dup_args[dup_args.length - 1] = dup_args.last.merge(if: :conditional?)
    else
      dup_args << { if: :conditional? }
    end
    expect(subject).to receive(:set_callback)
      .with(callback, type, *dup_args)
    subject.send(method, :test_method, if: :conditional?)
  end
end

RSpec.shared_examples 'An ActiveInteractor::Base instance respond_to' do
  it { should respond_to :execute_perform }
  it { should respond_to :execute_perform! }
  it { should respond_to :execute_rollback }
  it { should respond_to :fail_on_invalid_context? }
  it { should respond_to :perform }
  it { should respond_to :rollback }
  it { should respond_to :should_clean_context? }
  it { should respond_to :skip_clean_context! }

  ActiveModel::Validations.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end

  ActiveModel::Validations::HelperMethods.instance_methods.each do |method|
    it { should respond_to "context_#{method}".to_sym }
  end
end

RSpec.shared_examples 'An ActiveInteractor::Base instance methods' do
  describe '`#fail_on_invalid_context?`' do
    context 'when `#allow_context_to_be_invalid` is not invoked on the class' do
      it { expect(subject.fail_on_invalid_context?).to eq true }
    end

    context 'when `#allow_context_to_be_invalid` is not invoked on the class' do
      before { subject.class.allow_context_to_be_invalid }
      it { expect(subject.fail_on_invalid_context?).to eq false }
    end
  end

  describe '`#should_clean_context?`' do
    context 'when `#clean_context_on_completion` is not invoked on the class' do
      it { expect(subject.should_clean_context?).to eq false }
    end

    context 'when `#clean_context_on_completion` is invoked on the class' do
      before { subject.class.clean_context_on_completion }
      it { expect(subject.should_clean_context?).to eq true }

      context 'after invoking `#skip_clean_context!` on the instance' do
        before { subject.skip_clean_context! }
        it { expect(subject.should_clean_context?).to eq false }
      end
    end
  end

  describe '`#skip_clean_context!`' do
    before { subject.skip_clean_context! }
    it { expect(subject.instance_variable_get('@should_clean_context')).to eq false }
  end
end
