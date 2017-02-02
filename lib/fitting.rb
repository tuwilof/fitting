require 'fitting/version'
require 'fitting/documentation'
require 'fitting/request'
require 'fitting/response'
require 'fitting/configuration'
require 'fitting/json_file'
require 'fitting/yaml_file'
require 'fitting/formatter/response/macro_yaml'
require 'fitting/formatter/response/micro_yaml'
require 'fitting/report/response/macro'
require 'fitting/report/response/micro'
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
