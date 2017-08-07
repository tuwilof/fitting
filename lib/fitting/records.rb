require 'fitting/records/documented'
require 'fitting/records/tested'
require 'fitting/storage/documentation'
require 'fitting/storage/white_list'

module Fitting
  class Records
    def initialize
      @tested = Fitting::Records::Tested.new
    end

    def add(env_response)
      @tested.add(env_response)
    end

    def save_statistics
      documented.join(@tested)
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats_new', 'w') { |file| file.write(to_s) }
      File.open('fitting/not_covered_new', 'w') { |file| file.write(documented.requests.white_not_covered) }
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

    def documented
      return @documented if @documented

      @documented = Fitting::Records::Documented.new(
        Fitting::Storage::Documentation.tomogram.to_hash
      )
      @documented.joind_white_list(white_list)
      @documented
    end
  end
end
