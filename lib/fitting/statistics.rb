require 'fitting/documentation/response/route'
require 'fitting/storage/responses'
require 'fitting/documentation/request/route'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  class Statistics
    def initialize(response_routes, response_route_white)
      @response_routes = response_routes
      @response_route_white = response_route_white
    end

    def to_s
      if Fitting.configuration.white_list
        response_route_black = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Responses.all,
          @response_routes.black
        )

        request_route = Fitting::Documentation::Request::Route.new(response_route_black)
        statistics = Fitting::Documentation::Statistics.new(request_route, @response_routes.black, response_route_black)

        str_statistics =['[Black list]', statistics, '[White list]'].join("\n")
      end
      request_route = Fitting::Documentation::Request::Route.new(@response_route_white)
      statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(request_route, @response_routes.white, @response_route_white)

      [str_statistics, statistics_with_conformity_lists].compact.join("\n")
    end
  end
end
