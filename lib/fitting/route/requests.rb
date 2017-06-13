require 'multi_json'
require 'fitting/route/requests/statistics'
require 'fitting/route/requests/lists'
require 'fitting/route/requests/coverage'

module Fitting
  class Route
    class Requests
      def initialize(coverage)
        @coverage = coverage
      end

      def coverage_statistic
        stat = Fitting::Route::Requests::Coverage.new(@coverage).to_hash
        @stat = stat_each(stat)
      end

      def stat_each(stat)
        stat.each_with_object(default_statistic) do |date, res|
          date.last['cover_ratio'] = ratio(date)
          res_cover(ratio(date), res, info(date))
          path = date.first.split(' ')[1].size / 8
          find_max(path)
        end
      end

      def find_max(path)
        @max ||= 1
        @max = path.size if path.size > @max
      end

      def res_cover(ratio, res, info)
        if ratio == 100.0
          res['full cover'].push(info)
        elsif ratio == 0.0
          res['no cover'].push(info)
        else
          res['partial cover'].push(info)
        end
      end

      def default_statistic
        {
          'full cover' => [],
          'partial cover' => [],
          'no cover' => []
        }
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

      def to_hash
        @stat ||= coverage_statistic
      end

      def statistics
        @stat ||= coverage_statistic
        Fitting::Route::Requests::Statistics.new(
          @stat['full cover'].size,
          @stat['partial cover'].size,
          @stat['no cover'].size
        ).to_s
      end

      private

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
