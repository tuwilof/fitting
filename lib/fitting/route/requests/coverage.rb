module Fitting
  class Route
    class Requests
      class Coverage
        def initialize(coverage)
          @coverage = coverage
        end

        def to_hash
          stat = {}
          @coverage.coverage.map do |route|
            stat = coverage_stat(stat, route, '✔')
          end
          @coverage.not_coverage.map do |route|
            stat = not_coverage_stat(stat, route, '✖')
          end
          stat
        end

        private

        def coverage_stat(stat, route, symbol)
          macro_key = macro_key(route)
          micro_key = micro_key(route)
          stat = default_stat(stat, macro_key)
          stat[macro_key]['cover'].push(micro_key)
          stat[macro_key]['all'].push("#{symbol} #{route.split(' ')[2..3].join(' ')}")
          stat
        end

        def not_coverage_stat(stat, route, symbol)
          macro_key = macro_key(route)
          micro_key = micro_key(route)
          stat = default_stat(stat, macro_key)
          stat[macro_key]['not_cover'].push(micro_key)
          stat[macro_key]['all'].push("#{symbol} #{route.split(' ')[2..3].join(' ')}")
          stat
        end

        def default_stat(stat, macro_key)
          stat[macro_key] ||= {}
          stat[macro_key]['cover'] ||= []
          stat[macro_key]['not_cover'] ||= []
          stat[macro_key]['all'] ||= []
          stat
        end

        def macro_key(route)
          route.split(' ')[0..1].join(' ')
        end

        def micro_key(route)
          route.split(' ')[2..3].join(' ')
        end
      end
    end
  end
end
