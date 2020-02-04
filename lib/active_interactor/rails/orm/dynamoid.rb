# frozen_string_literal: true

require 'dynamoid/document'

Dynamoid::Document::ClassMethods.send :include, ActiveInteractor::Models
