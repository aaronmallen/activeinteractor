# frozen_string_literal: true

class MyInteractor < ActiveInteractor::Interactor
  argument :foo, String, required: true
  returns :bar, String, required: true

  def interaction
    context.bar = context.foo
  end
end
