# frozen_string_literal: true

require 'spec_helper'
begin
  require 'active_interactor/rails'

  RSpec.describe 'ActiveRecord Integration', type: :integration do
    let!(:active_record_base_mock) do
      build_class('ActiveRecordBaseMock') do
        def self.attr_accessor(*attributes)
          attribute_keys.concat(attributes.map(&:to_sym))
          super
        end

        def self.attribute_keys
          @attribute_keys ||= []
        end

        def initialize(attributes = nil, _options = {})
          (attributes || {}).each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        end

        def [](name)
          instance_variable_get("@#{name}")
        end

        def []=(name, value)
          instance_variable_set("@#{name}", value)
        end

        def attributes
          self.class.attribute_keys.each_with_object({}) do |key, hash|
            hash[key] = instance_variable_get("@#{key}")
          end
        end

        def to_h
          attributes.to_h
        end
      end
    end

    context 'after ActiveInteractor::Rails::ActiveRecord.include_helpers has been invoked' do
      before { ActiveInteractor::Rails::ActiveRecord.include_helpers }

      context 'after ActiveSupport.run_load_hooks has been invoked with :active_record_base' do
        before { ActiveSupport.run_load_hooks(:active_record_base, active_record_base_mock) }

        describe 'an ActiveRecord model class with .acts_as_context' do
          let(:model_mock) do
            build_class('ModelMock', active_record_base_mock) do
              attr_accessor :foo
              acts_as_context
            end
          end

          describe 'as an instance' do
            subject { model_mock.new }

            it { is_expected.to respond_to :called! }
            it { is_expected.to respond_to :fail! }
            it { is_expected.to respond_to :fail? }
            it { is_expected.to respond_to :failure? }
            it { is_expected.to respond_to :merge! }
            it { is_expected.to respond_to :rollback! }
            it { is_expected.to respond_to :success? }
            it { is_expected.to respond_to :successful? }
          end

          describe '.new' do
            subject { model_mock.new(attributes) }
            let(:attributes) { nil }

            it 'is expected not to receive #copy_flags!' do
              expect_any_instance_of(model_mock).not_to receive(:copy_flags!)
              subject
            end

            it 'is expected not to receive #copy_called!' do
              expect_any_instance_of(model_mock).not_to receive(:copy_called!)
              subject
            end

            it 'is expected to invoke super on parent class with nil attributes' do
              expect(active_record_base_mock).to receive(:new).with(nil)
              subject
            end

            context 'with attributes { :foo => "foo" }' do
              let(:attributes) { { foo: 'foo' } }

              it { expect { subject }.not_to raise_error }

              it 'is expected to receive #copy_flags!' do
                expect_any_instance_of(model_mock).to receive(:copy_flags!).with(foo: 'foo')
                subject
              end

              it 'is expected to receive #copy_called!' do
                expect_any_instance_of(model_mock).to receive(:copy_called!).with(foo: 'foo')
                subject
              end

              it 'is expected to invoke super on parent class with { :foo => "foo" }' do
                expect(active_record_base_mock).to receive(:new).with(foo: 'foo')
                subject
              end
            end

            context 'with attributes being an instance of ModelMock having attributes { :foo => "foo" }' do
              let(:previous_instance) { model_mock.new(foo: 'foo') }
              let(:attributes) { previous_instance }

              it { is_expected.to have_attributes(foo: 'foo') }

              context 'with _failed equal to true on previous instance' do
                before { previous_instance.instance_variable_set('@_failed', true) }

                it { is_expected.to be_failure }
              end

              context 'with _rolled_back equal to true on previous instance' do
                before { previous_instance.instance_variable_set('@_rolled_back', true) }

                it 'is expected to have instance_variable @_rolled_back eq to true' do
                  expect(subject.instance_variable_get('@_rolled_back')).to eq true
                end
              end

              context 'with _called eq to ["foo"] on previous instance' do
                before { previous_instance.instance_variable_set('@_called', %w[foo]) }

                it 'is expected to have instance_variable @_called eq to ["foo"]' do
                  expect(subject.instance_variable_get('@_called')).to eq %w[foo]
                end
              end
            end
          end

          describe '#merge!' do
            subject { model_mock.new(attributes).merge!(merge_instance) }
            context 'having attributes { :foo => nil }' do
              let(:attributes) { { foo: nil } }

              context 'with merging instance having attributes { :foo => "foo" }' do
                let(:merge_instance) { model_mock.new(foo: 'foo') }

                it { is_expected.to have_attributes(foo: 'foo') }

                context 'with _failed equal to true on merging instance' do
                  before { merge_instance.instance_variable_set('@_failed', true) }

                  it { is_expected.to be_failure }
                end

                context 'with _rolled_back equal to true on merging instance' do
                  before { merge_instance.instance_variable_set('@_rolled_back', true) }

                  it 'is expected to have instance_variable @_rolled_back eq to true' do
                    expect(subject.instance_variable_get('@_rolled_back')).to eq true
                  end
                end
              end
            end

            context 'having attributes { :foo => "foo"}' do
              let(:attributes) { { foo: 'foo' } }

              context 'with merging instance having attributes { :foo => "bar" }' do
                let(:merge_instance) { model_mock.new(foo: 'bar') }

                it { is_expected.to have_attributes(foo: 'bar') }

                context 'with _failed equal to true on merging instance' do
                  before { merge_instance.instance_variable_set('@_failed', true) }

                  it { is_expected.to be_failure }
                end

                context 'with _rolled_back equal to true on merging instance' do
                  before { merge_instance.instance_variable_set('@_rolled_back', true) }

                  it 'is expected to have instance_variable @_rolled_back eq to true' do
                    expect(subject.instance_variable_get('@_rolled_back')).to eq true
                  end
                end
              end
            end
          end
        end

        describe 'a basic interactor using an ActiveRecord model class as context' do
          let!(:model_mock) do
            require 'active_model'
            build_class('ModelMock', active_record_base_mock) do
              include ActiveModel::Validations
              attr_accessor :foo
              acts_as_context
            end
          end

          let(:interactor_class) do
            build_interactor do
              contextualize_with :model_mock

              def perform
                context.foo = 'foo'
              end
            end
          end

          include_examples 'a class with interactor methods'
          include_examples 'a class with interactor callback methods'
          include_examples 'a class with interactor context methods'

          describe '.context_class' do
            subject { interactor_class.context_class }

            it { is_expected.to eq model_mock }
          end

          describe '.perform' do
            subject { interactor_class.perform }

            it { is_expected.to be_a model_mock }
            it { is_expected.to be_successful }
            it { is_expected.to have_attributes(foo: 'foo') }
          end

          describe '.perform!' do
            subject { interactor_class.perform! }

            it { expect { subject }.not_to raise_error }
            it { is_expected.to be_a model_mock }
            it { is_expected.to be_successful }
            it { is_expected.to have_attributes(foo: 'foo') }
          end

          context 'failing the context on #perform' do
            let(:interactor_class) do
              build_interactor do
                contextualize_with :model_mock

                def perform
                  context.fail!
                end
              end
            end

            describe '.perform' do
              subject { interactor_class.perform }

              it { expect { subject }.not_to raise_error }
              it { is_expected.to be_a model_mock }
              it { is_expected.to be_failure }
              it 'is expected to #rollback' do
                expect_any_instance_of(interactor_class).to receive(:rollback)
                subject
              end
            end

            describe '.perform!' do
              subject { interactor_class.perform! }

              it { expect { subject }.to raise_error(ActiveInteractor::Error::ContextFailure) }
            end
          end
        end

        describe 'a basic organizer using an ActiveRecord model class as context' do
          let!(:model_mock) do
            require 'active_model'
            build_class('ModelMock', active_record_base_mock) do
              include ActiveModel::Validations
              attr_accessor :first_name, :last_name
              acts_as_context
            end
          end

          context 'with each organized interactor using the model' do
            let!(:test_interactor_1) do
              build_interactor('TestInteractor1') do
                contextualize_with :model_mock

                def perform
                  context.first_name = 'Test'
                end
              end
            end

            let!(:test_interactor_2) do
              build_interactor('TestInteractor2') do
                contextualize_with :model_mock

                def perform
                  context.last_name = 'User'
                end
              end
            end

            let(:interactor_class) do
              build_organizer do
                contextualize_with :model_mock
                organize :test_interactor_1, :test_interactor_2
              end
            end

            include_examples 'a class with interactor methods'
            include_examples 'a class with interactor callback methods'
            include_examples 'a class with interactor context methods'
            include_examples 'a class with organizer callback methods'

            describe '.perform' do
              subject { interactor_class.perform }

              it { is_expected.to be_a model_mock }
              it { is_expected.to be_successful }
              it { is_expected.to have_attributes(first_name: 'Test', last_name: 'User') }
            end
          end

          context 'with each organized interactor using their default context' do
            let!(:test_interactor_1) do
              build_interactor('TestInteractor1') do
                def perform
                  context.first_name = 'Test'
                end
              end
            end

            let!(:test_interactor_2) do
              build_interactor('TestInteractor2') do
                def perform
                  context.last_name = 'User'
                end
              end
            end

            let(:interactor_class) do
              build_organizer do
                contextualize_with :model_mock
                organize :test_interactor_1, :test_interactor_2
              end
            end

            include_examples 'a class with interactor methods'
            include_examples 'a class with interactor callback methods'
            include_examples 'a class with interactor context methods'
            include_examples 'a class with organizer callback methods'

            describe '.perform' do
              subject { interactor_class.perform }

              it { is_expected.to be_a model_mock }
              it { is_expected.to be_successful }
              it { is_expected.to have_attributes(first_name: 'Test', last_name: 'User') }
            end
          end
        end
      end
    end
  end
rescue LoadError
  RSpec.describe 'ActiveRecord Integration', type: :integration do
    pending 'Rails not found skipping specs...'
  end
end
