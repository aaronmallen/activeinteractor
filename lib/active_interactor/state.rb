# frozen_string_literal: true

module ActiveInteractor
  class State
    attr_reader :called

    def initialize
      @called = []
    end

    def called!(interactor)
      return self unless interactor.respond_to?(:rollback)

      called << interactor
      self
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def fail!(errors = nil)
      handle_errors(errors) if errors
      @_failed = true
      self
    end

    def failure?
      @_failed || false
    end
    alias fail? failure?

    def rollback!
      return self if rolled_back? || called.empty?

      called.reverse_each(&:rollback)
      @_rolled_back = true
      self
    end

    def rolled_back?
      @_rolled_back || false
    end

    def successful?
      !failure?
    end
    alias success? successful?

    private

    def handle_errors(errors)
      if errors.is_a?(String)
        self.errors.add(:interaction, errors)
      else
        self.errors.merge!(errors)
      end
    end
  end
end
