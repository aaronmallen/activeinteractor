# frozen_string_literal: true

require 'active_model'

require 'active_interactor/version'

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
#
# @author Aaron Allen <hello@aaronmallen.me>
# @since 0.0.1
# @version 0.1
module ActiveInteractor
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Configuration
  autoload :Context
  autoload :Interactor
  autoload :Organizer

  class << self
    # The ActiveInteractor configuration
    # @return [ActiveInteractor::Configuration] the configuration instance
    def configuration
      @configuration ||= Configuration.new
    end

    # Configures the ActiveInteractor gem
    #
    # @example Configure ActiveInteractor
    #  ActiveInteractor.configure do |config|
    #    config.logger = Rails.logger
    #  end
    #
    # @yield [ActiveInteractor#configuration]
    def configure
      yield(configuration)
    end

    # The ActiveInteractor logger object
    # @return [Logger] the configured logger instance
    def logger
      configuration.logger
    end
  end
end
