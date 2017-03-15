require 'fitting/documentation/response/route'
require 'fitting/storage/responses'
require 'fitting/documentation/request/route'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  class Statistics
    def initialize(response_routes, response_route_white)
      response_route_black = Fitting::Documentation::Response::Route.new(Fitting::Storage::Responses.all, response_routes.black)
      request_route_black = Fitting::Documentation::Request::Route.new(response_route_black)
      request_route_white = Fitting::Documentation::Request::Route.new(response_route_white)
      @statistics = Fitting::Documentation::Statistics.new(request_route_black, response_routes.black, response_route_black)
      @statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(request_route_white, response_routes.white, response_route_white)
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
