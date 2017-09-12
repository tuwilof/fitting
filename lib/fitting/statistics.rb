require 'fitting/statistics/template'

module Fitting
  class Statistics
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      FileUtils.mkdir_p 'fitting'
      Fitting::Statistics::Template.new(@tested_requests, Fitting.configuration).save
    end
  end
end
