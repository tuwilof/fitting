require 'fitting/documentation/response/monochrome_route/route'
require 'fitting/storage/responses'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'
require 'fitting/documentation/route'

module Fitting
  class Statistics
    def initialize(response)
      black = Fitting::Documentation::Route.new(response.routes.black, response.monochrome_route.black)
      white = Fitting::Documentation::Route.new(response.routes.white, response.monochrome_route.white)

      @statistics = Fitting::Documentation::Statistics.new(black)
      @statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(white)
    end

    def to_s
      if Fitting.configuration.white_list
        str_statistics = [
          ['[Black list]', @statistics].join("\n"),
          '[White list]'
        ].join("\n\n")
      end

      [str_statistics, @statistics_with_conformity_lists, "\n"].compact.join("\n")
    end
  end
end
