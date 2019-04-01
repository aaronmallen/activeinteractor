# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Organizer do
  describe "A class that inherits #{described_class} called \"TestOrganizer\"" do
    subject(:organizer) { build_organizer('TestOrganizer') }
    include_examples 'An ActiveInteractor::Base class'
    it { should respond_to? :organize }
    it { should respond_to? :organized }

    describe 'as an instance' do
      subject { organizer.new }
      include_examples 'An ActiveInteractor::Base instance'
    end

    context 'with two (2) Interactors: "TestInteractor1" and "TestInteractor2"' do
      let(:interactors) { Array.new(2) { |i| build_interactor("TestInteractor#{i + 1}") } }

      describe '`#organize`' do
        subject { organizer.organize(*interactors) }
        it { should be_an Array }
        it { should match_array(interactors) }
      end

      describe '`#organized`' do
        subject { organizer.organized }
        before { organizer.organize(*interactors) }

        it { should be_an Array }
        it { should match_array(interactors) }
      end

      describe '`#perform`' do
        subject { organizer.perform }
        before { organizer.organize(*interactors) }

        it 'should invoke `#skip_clean_context!` on both interactors' do
          expect_any_instance_of(TestInteractor1).to receive(:skip_clean_context!).and_call_original
          expect_any_instance_of(TestInteractor2).to receive(:skip_clean_context!).and_call_original
          subject
        end

        it 'should invoke `#excute_perform!` on both interactors' do
          expect_any_instance_of(TestInteractor1).to receive(:execute_perform!).and_call_original
          expect_any_instance_of(TestInteractor2).to receive(:execute_perform!).and_call_original
          subject
        end

        context 'when `TestInteractor1 `raises `ActiveInteractor::Context::Failure`' do
          before do
            error = ActiveInteractor::Context::Failure.new
            allow(ActiveInteractor.logger).to receive(:error).and_return(true)
            allow_any_instance_of(TestInteractor1).to receive(:execute_perform!)
              .and_raise(error)
          end

          it 'should not invoke `#execute_perform!` on `TestInteractor2`' do
            expect_any_instance_of(TestInteractor2).not_to receive(:execute_perform!)
          end

          it 'should invoke `#rollback!` on `TestOrganizer::Context`' do
            expect_any_instance_of(TestOrganizer::Context).to receive(:rollback!).and_call_original
            subject
          end
        end
      end
    end
  end
end
