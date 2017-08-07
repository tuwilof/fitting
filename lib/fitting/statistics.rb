require 'fitting/storage/white_list'
require 'fitting/storage/documentation'
require 'fitting/records/documented'
require 'fitting/records/statistics'

module Fitting
  class Statistics
    def initialize(tested)
      @tested = tested
    end

    def save
      documented.join(@tested)
      @white_statistics ||= Fitting::Records::Statistics.new(documented.requests.white)
      @black_statistics ||= Fitting::Records::Statistics.new(documented.requests.black)
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(to_s) }
      File.open('fitting/not_covered', 'w') { |file| file.write(@white_statistics.statistics_with_not_covered_lists) }
    end

    def documented
      return @documented if @documented

      @documented = Fitting::Records::Documented.new(
        Fitting::Storage::Documentation.tomogram.to_hash
      )
      @documented.joind_white_list(white_list)
      @documented
    end

    def to_s
      if documented.requests.to_a.size > documented.requests.white.size
        [
          ['[Black list]', @black_statistics.statistics_with_conformity_lists].join("\n"),
          ['[White list]', @white_statistics.statistics_with_conformity_lists].join("\n"),
          ''
        ].join("\n\n")
      else
        [@white_statistics.statistics_with_conformity_lists, "\n\n"].join
      end
    end

    def white_list
      Fitting::Storage::WhiteList.new(
        Fitting.configuration.white_list,
        Fitting.configuration.resource_white_list,
        Fitting::Storage::Documentation.tomogram.to_resources
      ).to_a
    end
  end
end
