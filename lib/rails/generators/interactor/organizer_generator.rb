# frozen_string_literal: true

require 'active_interactor/rails/generators/interactor'

module Interactor
  class OrganizerGenerator < Interactor::Generator
    desc 'Generate an interactor organizer'
    argument :interactors, type: :array, default: [], banner: 'name name'
  end
end
