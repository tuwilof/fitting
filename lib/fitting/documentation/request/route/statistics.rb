module Fitting
  module Documentation
    module Request
      class Route
        class Statistics
          def initialize(request_routes)
            @request_routes = request_routes
          end

          def to_s
            full_count = @request_routes.to_hash['full cover'].size
            part_count = @request_routes.to_hash['partial cover'].size
            no_count = @request_routes.to_hash['no cover'].size
            total_count = full_count + part_count + no_count
            full_percentage = (full_count.to_f / total_count.to_f * 100.0).round(2)
            part_percentage = (part_count.to_f / total_count.to_f * 100.0).round(2)
            no_percentage = (no_count.to_f / total_count.to_f * 100.0).round(2)

            "API requests with fully implemented responses: #{full_count} (#{full_percentage}% of #{total_count}).\n"\
            "API requests with partially implemented responses: #{part_count} (#{part_percentage}% of #{total_count}).\n"\
            "API requests with no implemented responses: #{no_count} (#{no_percentage}% of #{total_count}).\n"
          end
        end
      end
    end
  end
end
