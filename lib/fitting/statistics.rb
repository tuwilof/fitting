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
        str_statistics = [
          ['[Black list]', @statistics].join("\n"),
          '[White list]'
        ].join("\n\n")
      end

      [str_statistics, @statistics_with_conformity_lists, "\n"].compact.join("\n")
    end
  end
end
