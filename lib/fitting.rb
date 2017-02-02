require 'fitting/version'
require 'fitting/documentation'
require 'fitting/configuration'
require 'fitting/formatter/response/macro_yaml'
require 'fitting/formatter/response/micro_yaml'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
