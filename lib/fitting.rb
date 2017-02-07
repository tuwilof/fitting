require 'fitting/version'
require 'fitting/documentation'
require 'fitting/configuration'

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
