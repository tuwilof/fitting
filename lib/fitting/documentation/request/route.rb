require 'multi_json'

module Fitting
  module Documentation
    module Request
      class Route
        def initialize(response_routes)
          @response_routes = response_routes
        end

        def coverage_statistic
          stat = {}
          @response_routes.coverage.map do |route|
            key = route.split(' ')[0..1].join(' ')
            stat[key] ||= {}
            stat[key]['cover'] ||= 0
            stat[key]['not_cover'] ||= 0
            stat[key]['cover'] += 1
          end
          @response_routes.not_coverage.map do |route|
            key = route.split(' ')[0..1].join(' ')
            stat[key] ||= {}
            stat[key]['cover'] ||= 0
            stat[key]['not_cover'] ||= 0
            stat[key]['not_cover'] += 1
          end
          @stat = stat.inject({}) do |res, date|
            key = date.last['cover_ratio'] = (date.last['cover'].to_f / date.last['not_cover'].to_f * 100.0).round(2)
            res[key] ||= []
            res[key].push(date.first)
            res
          end
        end

        def to_hash
          @stat ||= coverage_statistic
        end
      end
    end
  end
end
