# frozen_string_literal: true

module Spec
  module Coverage
    module Reporters
      module Codacy
        class << self
          def load
            return EMPTY_LOAD_RESULT unless load_dependencies

            [formatters, initialize_steps, run_steps]
          end

          private

          def load_dependencies
            require 'codacy-coverage'
            true
          rescue LoadError
            puts 'Skipping Codacy Coverage reporting...'
            false
          end

          def formatters
            { codacy: ::Codacy::Formatter }
          end

          def initialize_steps
            []
          end

          def run_steps
            []
          end
        end
      end
    end
  end
end
