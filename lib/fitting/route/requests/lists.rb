module Fitting
  class Route
    class Requests
      class Lists
        def initialize(stat, max)
          @stat = stat
          @max = max
        end

        def to_s
          [
            list_fully_implemented,
            list_partially_implemented,
            list_no_implemented
          ].compact.join("\n\n")
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

        def fully_implemented
          @fully_implemented ||= stat_full_cover.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
        end

        def partially_implemented
          @partially_implemented ||= stat_partial_cover.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
        end

        def no_implemented
          @no_implemented ||= stat_no_cover.sort do |first, second|
            first.split("\t")[1] <=> second.split("\t")[1]
          end
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
      end
    end
  end
end
