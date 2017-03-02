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
            stat[macro_key]['all'] ||= []
            stat[macro_key]['all'].push("✔ #{route.split(' ')[2..3].join(' ')}")
          end
          @response_routes.not_coverage.map do |route|
            macro_key = route.split(' ')[0..1].join(' ')
            micro_key = route.split(' ')[2..3].join(' ')
            stat[macro_key] ||= {}
            stat[macro_key]['cover'] ||= []
            stat[macro_key]['not_cover'] ||= []
            stat[macro_key]['not_cover'].push(micro_key)
            stat[macro_key]['all'] ||= []
            stat[macro_key]['all'].push("✖ #{route.split(' ')[2..3].join(' ')}")
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
            info = {date.first => {
              'cover' => date.last['cover'],
              'not_cover' => date.last['not_cover'],
              'all' => "#{beautiful_output(date.last)}"
            }}
            if ratio == 100.0
              res['full cover'].push(info)
            elsif ratio == 0.0
              res['no cover'].push(info)
            else
              res['partial cover'].push(info)
            end
            path = date.first.split(' ')[1].size / 8
            @max ||= 1
            if path.size > @max
              @max = path.size
            end
            res
          end
        end

        def to_hash
          @stat ||= coverage_statistic
        end

        def fully_implemented
          @fully_implemented = @stat['full cover'].map do |response|
            "#{response.first.to_a.first.split(' ').join("\t")}#{"\t"*(@max-response.first.to_a.first.split(' ')[1].size/8)}#{response.first.to_a.last['all']}"
          end.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
        end

        def partially_implemented
          @partially_implemented ||= @stat['partial cover'].map do |response|
            "#{response.first.to_a.first.split(' ').join("\t")}#{"\t"*(@max-response.first.to_a.first.split(' ')[1].size/8)}#{response.first.to_a.last['all']}"
          end.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
        end

        def no_implemented
          @no_implemented ||= @stat['no cover'].map do |response|
            "#{response.first.to_a.first.split(' ').join("\t")}#{"\t"*(@max-response.first.to_a.first.split(' ')[1].size/8)}#{response.first.to_a.last['all']}"
          end.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
        end

        private

        def beautiful_output(hash)
          methods = {}
          res = []
          hash['cover'].map do |response|
            method, index = response.split(' ')
            methods[method] ||= []
            methods[method][index.to_i] = {'method' => method, 'cover' => true}
          end
          hash['not_cover'].map do |response|
            method, index = response.split(' ')
            methods[method] ||= []
            methods[method][index.to_i] = {'method' => method, 'cover' => false}
          end
          methods.map do |method|
            method.last.size.times do |index|
              res.push("#{method.last[index]['cover'] ? '✔' : '✖'} #{method.first}")
            end
          end
          res.join(' ')
        end
      end
    end
  end
end
