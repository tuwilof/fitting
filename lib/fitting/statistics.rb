require 'fitting/statistics/template'

module Fitting
  class Statistics
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      make_dir('fitting')
      if Fitting.configuration.is_a?(Array)
        Fitting.configuration.each do |config|
          make_dir("fitting/#{config.title}")
          Fitting::Statistics::Template.new(@tested_requests, config).save
        end
      else
        Fitting::Statistics::Template.new(@tested_requests, Fitting.configuration).save
      end
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
