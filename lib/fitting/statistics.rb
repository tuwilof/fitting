require 'fitting/storage/white_list'
require 'fitting/storage/documentation'
require 'fitting/records/documented'

module Fitting
  class Statistics
    def initialize(tested)
      @tested = tested
    end

    def save
      documented.join(@tested)
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(to_s) }
      File.open('fitting/not_covered', 'w') { |file| file.write(documented.requests.white_not_covered) }
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
          ['[Black list]', documented.requests.black_statistics_with_conformity_lists].join("\n"),
          ['[White list]', documented.requests.white_statistics_with_conformity_lists].join("\n"),
          ''
        ].join("\n\n")
      else
        [documented.requests.white_statistics_with_conformity_lists, "\n\n"].join
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
