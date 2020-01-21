# frozen_string_literal: true

module Spec
  module Coverage
    class Runner
      attr_accessor :filtered_files, :formatters, :tracked_files

      def self.start(&block)
        instance = new
        instance.instance_eval(&block) if block
        instance.start
      end

      def initialize(options = {})
        load_reporters!
        @formatters = options[:formatters] || []
        @filtered_files = options[:filtered_files] || []
        @tracked_files = options[:tracked_files] || []
      end

      def add_formatter(formatter)
        formatter_class = reporters[:formatters][formatter.to_sym]
        formatters << formatter_class if formatter_class
        self
      end

      def filter(pattern)
        filtered_files << pattern
        self
      end

      def start
        initialize_reporters
        run_reporters
      end

      def track(pattern)
        tracked_files << pattern
        self
      end

      private

      attr_reader :reporters

      def initialize_reporters
        reporters[:initialize_steps].each { |step| step.call(self) }
      end

      def load_reporters!
        @reporters = { formatters: {}, initialize_steps: [], run_steps: [] }
        %w[SimpleCov Codacy].each do |dep|
          reporter = Reporters.const_get(dep)
          formatters, initialize_steps, run_steps = reporter.load
          @reporters[:formatters].merge!(formatters)
          @reporters[:initialize_steps].concat(initialize_steps)
          @reporters[:run_steps].concat(run_steps)
        end
      end

      def run_reporters
        reporters[:run_steps].each { |step| step.call(self) }
      end
    end
  end
end
