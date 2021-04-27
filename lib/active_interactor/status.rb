# frozen_string_literal: true

module ActiveInteractor
  class Status
    STATUS = {
      failed_on_input: 1,
      failed_on_runtime: 2,
      failed_on_output: 3,
      success: 0
    }.freeze

    attr_reader :status

    def initialize
      @status = STATUS[:success]
    end

    def called
      @called ||= []
    end

    def called!(interactor)
      called << interactor
    end

    def fail?
      !success?
    end
    alias failure? fail?

    def fail_on_input!
      @status = STATUS[:failed_on_input]
    end

    def fail_on_output!
      @status = STATUS[:failed_on_output]
    end

    def fail_on_runtime!
      @status = STATUS[:failed_on_runtime]
    end

    def failed_on_input?
      status == STATUS[:failed_on_input]
    end

    def failed_on_output?
      status == STATUS[:failed_on_output]
    end

    def failed_on_runtime?
      status == STATUS[:failed_on_runtime]
    end

    def success?
      status == STATUS[:success]
    end
    alias successful? success?
  end
end
