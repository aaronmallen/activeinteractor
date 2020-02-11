# frozen_string_literal: true

require 'active_model'
require 'active_support/callbacks'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'active_support/dependencies/autoload'
require 'logger'
require 'ostruct'

require 'active_interactor/configurable'
require 'active_interactor/config'
require 'active_interactor/version'

# An {Base interactor} is a simple, single-purpose service object. {Base Interactors} can be used to reduce the
# responsibility of your controllers, workers, and models and encapsulate your application's
# {https://en.wikipedia.org/wiki/Business_logic business logic}. Each {Base interactor} represents one thing that your
# application does.
#
# Each {Base interactor} has it's own immutable {Context::Base context} which contains everything the
# {Base interactor} needs to do its work. When an {Base interactor} does its single purpose, it affects its given
# {Context::Base context}.
#
# @see https://medium.com/@aaronmallen/activeinteractor-8557c0dc78db Basic Usage
# @see https://github.com/aaronmallen/activeinteractor/wiki Advanced Usage
# @see https://github.com/aaronmallen/activeinteractor Source Code
# @see https://github.com/aaronmallen/activeinteractor/issues Issues
#
# ## License
#
# Copyright (c) 2019 Aaron Allen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base

  # {Context::Base Context} classes and modules
  #
  # @see https://github.com/aaronmallen/activeinteractor/wiki/Context Context
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.0
  module Context
    extend ActiveSupport::Autoload

    autoload :Attributes
    autoload :Base
    autoload :Errors
    autoload :Loader
    autoload :Status
  end

  # {Base Interactor} classes and modules
  #
  # @see https://github.com/aaronmallen/activeinteractor/wiki/Interactors Interactors
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.0
  module Interactor
    extend ActiveSupport::Autoload

    autoload :Callbacks
    autoload :Context
    autoload :Perform
    autoload :Worker
  end

  autoload :Models

  # {Organizer::Base Organizer} classes and modules
  #
  # @see https://github.com/aaronmallen/activeinteractor/wiki/Interactors#organizers Organizers
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since 0.1.0
  module Organizer
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Callbacks
    autoload :InteractorInterface
    autoload :InteractorInterfaceCollection
    autoload :Organize
    autoload :Perform
  end

  eager_autoload do
    autoload :Error
  end
end

require 'active_interactor/rails' if defined?(::Rails)
