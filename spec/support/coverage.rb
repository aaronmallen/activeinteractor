# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

module ActiveInteractor
  module Spec
    class Coverage
      DEFAULT_COVERAGE_TYPE = 'unit'
      EXCLUDED_FILES_PATTERN = '/spec/'
      TRACKED_FILES_PATTERN = 'lib/**/*.rb'

      FORMATTERS = [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::LcovFormatter
      ].freeze

      class << self
        def start
          setup_lcov_formatter
          start_simplecov
        end

        private

        def simplecov_formatter
          @simplecov_formatter ||= SimpleCov::Formatter::MultiFormatter.new(FORMATTERS)
        end

        def setup_lcov_formatter
          coverage_type = ENV.fetch('COVERAGE_TYPE', DEFAULT_COVERAGE_TYPE)

          SimpleCov::Formatter::LcovFormatter.config do |config|
            config.report_with_single_file = true
            config.single_report_path = "coverage/#{coverage_type}_lcov.info"
          end
        end

        def start_simplecov
          SimpleCov.start do
            add_filter EXCLUDED_FILES_PATTERN
            enable_coverage :branch
            track_files TRACKED_FILES_PATTERN
            formatter simplecov_formatter
          end
        end
      end
    end
  end
end
