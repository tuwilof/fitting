module Fitting
  class Route
    class Requests
      class Lists
        def initialize(full_cover, partial_cover, no_cover, max)
          @full_cover = full_cover
          @partial_cover = partial_cover
          @no_cover = no_cover
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
          return nil if fully_implemented == []
          ['Fully conforming requests:', fully_implemented].join("\n")
        end

        def list_partially_implemented
          return nil if partially_implemented == []
          ['Partially conforming requests:', partially_implemented].join("\n")
        end

        def list_no_implemented
          return nil if no_implemented == []
          ['Non-conforming requests:', no_implemented].join("\n")
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
          @full_cover.map do |response|
            cover_request(response)
          end
        end

        def stat_partial_cover
          @partial_cover.map do |response|
            cover_request(response)
          end
        end

        def stat_no_cover
          @no_cover.map do |response|
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
