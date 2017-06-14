module Fitting
  class Route
    class Requests
      class Combine
        def initialize(stat)
          @stat = stat
          @full_cover = []
          @partial_cover = []
          @no_cover = []
        end

        def to_hash
          stat_each
          @to_hash ||= {
            'full cover' => @full_cover,
            'partial cover' => @partial_cover,
            'no cover' => @no_cover
          }
        end

        def max
          stat_each
          @max
        end

        def full_cover
          stat_each
          @full_cover
        end

        def partial_cover
          stat_each
          @partial_cover
        end

        def no_cover
          stat_each
          @no_cover
        end

        private

        def stat_each
          @stat_each ||= @stat.to_hash.map do |date|
            date.last['cover_ratio'] = ratio(date)
            res_cover(ratio(date), info(date))
            path = date.first.split(' ')[1].size / 8
            find_max(path)
          end
        end

        def find_max(path)
          @max ||= 1
          @max = path.size if path.size > @max
        end

        def res_cover(ratio, info)
          if ratio == 100.0
            @full_cover.push(info)
          elsif ratio == 0.0
            @no_cover.push(info)
          else
            @partial_cover.push(info)
          end
        end

        def ratio(date)
          (date.last['cover'].size.to_f /
            (date.last['cover'].size + date.last['not_cover'].size).to_f * 100.0).round(2)
        end

        def info(date)
          { date.first => {
            'cover' => date.last['cover'],
            'not_cover' => date.last['not_cover'],
            'all' => beautiful_output(date.last).to_s
          } }
        end

        def beautiful_output(hash)
          methods = {}
          res = []
          methods = beautiful_cover(hash, methods)
          methods = beautiful_not_cover(hash, methods)
          methods.map do |method|
            method.last.size.times do |index|
              res.push("#{method.last[index]['cover'] ? '✔' : '✖'} #{method.first}")
            end
          end
          res.join(' ')
        end

        def beautiful_cover(hash, methods)
          hash['cover'].map do |response|
            method, index = response.split(' ')
            methods[method] ||= []
            methods[method][index.to_i] = { 'method' => method, 'cover' => true }
          end
          methods
        end

        def beautiful_not_cover(hash, methods)
          hash['not_cover'].map do |response|
            method, index = response.split(' ')
            methods[method] ||= []
            methods[method][index.to_i] = { 'method' => method, 'cover' => false }
          end
          methods
        end
      end
    end
  end
end
