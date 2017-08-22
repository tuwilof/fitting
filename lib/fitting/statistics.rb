require 'fitting/statistics/analysis'
require 'fitting/statistics/measurement'

module Fitting
  class Statistics
    def initialize(tested, source_documented)
      @tested = tested
      @source_documented = source_documented
    end

    def save
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(stats) }
      File.open('fitting/not_covered', 'w') { |file| file.write(not_covered) }
    end

    def stats
      if documented.requests.to_a.size > documented.requests.white.size
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

    def documented
      return @documented if @documented

      @documented = @source_documented
      @documented.join(@tested)
      @documented
    end

    def white_statistics
      @white_statistics ||= Fitting::Statistics::Analysis.new(white_measurement)
    end

    def black_statistics
      @black_statistics ||= Fitting::Statistics::Analysis.new(black_measurement)
    end

    def white_measurement
      @white_measurement ||= Fitting::Statistics::Measurement.new(documented.requests.white)
    end

    def black_measurement
      @black_measurement ||= Fitting::Statistics::Measurement.new(documented.requests.black)
    end
  end
end
