require 'fitting/version'
require 'fitting/documentation'
require 'fitting/request'
require 'fitting/response'
require 'fitting/configuration'
require 'fitting/json_file'
require 'fitting/yaml_file'
require 'fitting/rspec_json_formatter'
require 'fitting/report/test'
require 'fitting/report/request'
require 'fitting/report/response'
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
