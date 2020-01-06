# frozen_string_literal: true

Dir[File.expand_path('active_interactor/*.rb', __dir__)].sort.each { |file| require file }
Dir[File.expand_path('interactor/*.rb', __dir__)].sort.each { |file| require file }
