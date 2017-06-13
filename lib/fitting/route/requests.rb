require 'multi_json'

module Fitting
  class Route
    class Requests
      def initialize(coverage)
        @coverage = coverage
      end

      def coverage_statistic
        stat = {}
        @coverage.coverage.map do |route|
          stat = coverage_stat(stat, route, '✔')
        end
        @coverage.not_coverage.map do |route|
          stat = not_coverage_stat(stat, route, '✖')
        end
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

      def to_hash
        @stat ||= coverage_statistic
      end

      def fully_implemented
        @stat ||= coverage_statistic
        @fully_implemented ||= stat_full_cover.sort do |first, second|
          first.split("\t")[1] <=> second.split("\t")[1]
        end
      end

      def partially_implemented
        @stat ||= coverage_statistic
        @partially_implemented ||= stat_partial_cover.sort do |first, second|
          first.split("\t")[1] <=> second.split("\t")[1]
        end
      end

      def no_implemented
        @stat ||= coverage_statistic
        @no_implemented ||= stat_no_cover.sort do |first, second|
          first.split("\t")[1] <=> second.split("\t")[1]
        end
      end

      def statistics
        @stat ||= coverage_statistic
        [
          "API requests with fully implemented responses: #{full_count} (#{full_percentage}% of #{total_count}).",
          "API requests with partially implemented responses: #{part_count} (#{part_percentage}% of #{total_count}).",
          "API requests with no implemented responses: #{no_count} (#{no_percentage}% of #{total_count})."
        ].join("\n")
      end

      def conformity_lists
        @stat ||= coverage_statistic
        [
          list_fully_implemented,
          list_partially_implemented,
          list_no_implemented
        ].compact.join("\n\n")
      end

      private

      def stat_full_cover
        @stat['full cover'].map do |response|
          cover_request(response)
        end
      end

      def stat_partial_cover
        @stat['partial cover'].map do |response|
          cover_request(response)
        end
      end

      def stat_no_cover
        @stat['no cover'].map do |response|
          cover_request(response)
        end
      end

      def cover_request(response)
        "#{cover_method(response)}#{tabulation(response)}#{cover_status(response)}"
      end

      def cover_method(response)
        response.first.to_a.first.split(' ').join("\t")
      end

      def tabulation(response)
        "\t" * (@max - response.first.to_a.first.split(' ')[1].size / 8)
      end

      def cover_status(response)
        response.first.to_a.last['all']
      end

      def full_count
        @full_count ||= @stat.to_hash['full cover'].size
      end

      def part_count
        @part_count ||= @stat.to_hash['partial cover'].size
      end

      def no_count
        @no_count ||= @stat.to_hash['no cover'].size
      end

      def total_count
        @total_count ||= full_count + part_count + no_count
      end

      def full_percentage
        @full_percentage ||= (full_count.to_f / total_count.to_f * 100.0).round(2)
      end

      def part_percentage
        @part_percentage ||= (part_count.to_f / total_count.to_f * 100.0).round(2)
      end

      def no_percentage
        @no_percentage ||= (no_count.to_f / total_count.to_f * 100.0).round(2)
      end

      def list_fully_implemented
        @fully_implemented ||= fully_implemented.join("\n")
        if @fully_implemented != ''
          return ['Fully conforming requests:', fully_implemented].join("\n")
        end
        nil
      end

      def list_partially_implemented
        @partially_implemented ||= partially_implemented.join("\n")
        if @partially_implemented != ''
          return ['Partially conforming requests:', partially_implemented].join("\n")
        end
        nil
      end

      def list_no_implemented
        @no_implemented ||= no_implemented.join("\n")
        if @no_implemented != ''
          return ['Non-conforming requests:', no_implemented].join("\n")
        end
        nil
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
