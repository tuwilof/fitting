require 'fitting/version'
require 'fitting/documentation'
require 'fitting/request'
require 'fitting/response'
require 'fitting/configuration'
require 'tomogram_routing'

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
