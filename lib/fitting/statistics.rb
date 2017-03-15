require 'fitting/documentation/route'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  class Statistics
    def initialize(response)
      @statistics = Fitting::Documentation::Statistics.new(
        Fitting::Documentation::Route.new(response.routes.black, response.monochrome_route.black))
      @statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(
        Fitting::Documentation::Route.new(response.routes.white, response.monochrome_route.white))
    end

    def to_s
      if Fitting.configuration.white_list
        [
          ['[Black list]', @statistics].join("\n"),
          ['[White list]', @statistics_with_conformity_lists].join("\n"),
          ""
        ].join("\n\n")
      else
        [@statistics_with_conformity_lists, "\n\n"].join
      end
    end
  end
end
