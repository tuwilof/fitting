require 'fitting/documentation/response/routes'
require 'fitting/documentation/response/monochrome_route'
require 'fitting/documentation/route'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  module Documentation
    class Response
      def initialize(documentation, white_list, all_responses)
        @routes = Fitting::Documentation::Response::Routes.new(documentation, white_list)
        @monochrome_route = Fitting::Documentation::Response::MonochromeRoute.new(all_responses, @routes)
        @statistics = Fitting::Documentation::Statistics.new(
          Fitting::Documentation::Route.new(@routes.black, @monochrome_route.black))
        @statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(
          Fitting::Documentation::Route.new(@routes.white, @monochrome_route.white))
      end

      def routes
        @routes
      end

      def monochrome_route
        @monochrome_route
      end

      def statistics
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
end
