# frozen_string_literal: true

module Spec
  module Coverage
    module Reporters
      module SimpleCov
        class << self
          def load
            return EMPTY_LOAD_RESULT unless load_dependencies

            [formatters, initialize_steps, run_steps]
          end

          private

          def load_dependencies
            require 'simplecov'
            true
          rescue LoadError
            puts 'Skipping SimpleCov reporting...'
            false
          end

          def formatters
            { simple_cov_html: ::SimpleCov::Formatter::HTMLFormatter }
          end

          def initialize_steps
            [setup_formatters]
          end

          def run_steps
            [start_simplecov]
          end

          def setup_formatters
            lambda do |runner|
              ::SimpleCov.formatter = ::SimpleCov::Formatter::MultiFormatter.new(runner.formatters)
            end
          end

          def start_simplecov
            lambda do |runner|
              ::SimpleCov.start do
                runner.tracked_files.each { |f| track_files f }
                runner.filtered_files.each { |f| add_filter f }
              end
            end
          end
        end
      end
    end
  end
end
