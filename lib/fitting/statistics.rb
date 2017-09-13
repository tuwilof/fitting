require 'fitting/statistics/template'

module Fitting
  class Statistics
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      FileUtils.mkdir_p 'fitting'
      if Fitting.configuration.is_a?(Array)
        Fitting.configuration.each do |config|
          FileUtils.mkdir_p "fitting/#{config.title}"
          Fitting::Statistics::Template.new(@tested_requests, config).save
        end
      else
        Fitting::Statistics::Template.new(@tested_requests, Fitting.configuration).save
      end
    end
  end
end
