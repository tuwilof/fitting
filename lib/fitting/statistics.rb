require 'fitting/statistics/analysis'
require 'fitting/statistics/measurement'
require 'fitting/records/unit'

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
      if @documented_requests.to_a.size > @documented_requests.white.size
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
      @white_unit ||= Fitting::Records::Unit.new(@documented_requests.white, @tested_requests)
    end

    def black_unit
      @black_unit ||= Fitting::Records::Unit.new(@documented_requests.black, @tested_requests)
    end
  end
end
