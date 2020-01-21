# frozen_string_literal: true

module Spec
  module Coverage
    module Reporters
      EMPTY_LOAD_RESULT = [{}, [], []].freeze
    end
  end
end

Dir[File.expand_path('reporters/*.rb', __dir__)].sort.each { |file| require file }
