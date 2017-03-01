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
            macro_key = route.split(' ')[0..1].join(' ')
            micro_key = route.split(' ')[2..3].join(' ')
            stat[macro_key] ||= {}
            stat[macro_key]['cover'] ||= []
            stat[macro_key]['not_cover'] ||= []
            stat[macro_key]['cover'].push(micro_key)
          end
          @response_routes.not_coverage.map do |route|
            macro_key = route.split(' ')[0..1].join(' ')
            micro_key = route.split(' ')[2..3].join(' ')
            stat[macro_key] ||= {}
            stat[macro_key]['cover'] ||= []
            stat[macro_key]['not_cover'] ||= []
            stat[macro_key]['not_cover'].push(micro_key)
          end
          @stat = stat.inject(
            {
              'full cover' => [],
              'partial cover' => [],
              'no cover' => []
            }
          ) do |res, date|
            ratio = date.last['cover_ratio'] =
              (date.last['cover'].size.to_f /
                (date.last['cover'].size + date.last['not_cover'].size).to_f * 100.0).round(2)
            info = {date.first => {'cover' => date.last['cover'], 'not_cover' => date.last['not_cover']}}
            if ratio == 100.0
              res['full cover'].push(info)
            elsif ratio == 0.0
              res['no cover'].push(info)
            else
              res['partial cover'].push(info)
            end
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
