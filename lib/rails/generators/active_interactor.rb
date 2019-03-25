# frozen_string_literal: true

require 'rails/generators/named_base'

Dir[File.expand_path('active_interactor/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].each { |file| require file }

require 'active_interactor/rails/generators/interactor_generator'
