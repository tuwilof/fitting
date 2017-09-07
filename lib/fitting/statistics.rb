require 'fitting/statistics/analysis'
require 'fitting/statistics/measurement'
require 'fitting/records/unit/request'

module Fitting
  class Statistics
    def initialize(documented_requests, tested_requests)
      @documented_requests = documented_requests
      @tested_requests = tested_requests
    end

    def save
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(stats) }
      File.open('fitting/not_covered', 'w') { |file| file.write(not_covered) }
    end

    def stats
      if @documented_requests.to_a.size > documented_requests_white.size
        [
          ['[Black list]', black_statistics.all].join("\n"),
          ['[White list]', white_statistics.all].join("\n"),
          ''
        ].join("\n\n")
      else
        [white_statistics.all, "\n\n"].join
      end
    end

    def not_covered
      Fitting::Statistics::NotCoveredResponses.new(white_measurement).to_s
    end

    def white_statistics
      @white_statistics ||= Fitting::Statistics::Analysis.new(white_measurement)
    end

    def black_statistics
      @black_statistics ||= Fitting::Statistics::Analysis.new(black_measurement)
    end

    def white_measurement
      @white_measurement ||= Fitting::Statistics::Measurement.new(white_unit)
    end

    def black_measurement
      @black_measurement ||= Fitting::Statistics::Measurement.new(black_unit)
    end

    def white_unit
      @white_unit_requests ||= documented_requests_white.inject([]) do |res, documented_request|
        res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
      end
    end

    def black_unit
      @black_unit_requests ||= documented_requests_black.inject([]) do |res, documented_request|
        res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
      end
    end

    def documented_requests_white
      @documented_requests_white ||= @documented_requests.find_all do |request|
        request.white
      end
    end

    def documented_requests_black
      @documented_requests_black ||= @documented_requests.find_all do |request|
        !request.white
      end
    end
  end
end
