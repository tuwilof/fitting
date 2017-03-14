module Fitting
  module Documentation
    module Request
      class Route
        class ConformityLists
          def initialize(request_routes)
            @request_routes = request_routes
          end

          def to_s
            @fully_implemented ||= @request_routes.fully_implemented.join("\n")
            @partially_implemented ||= @request_routes.partially_implemented.join("\n")
            @no_implemented ||= @request_routes.no_implemented.join("\n")

            [
              ['Fully conforming requests:', @fully_implemented].join("\n"),
              ['Partially conforming requests:', @partially_implemented].join("\n"),
              ['Non-conforming requests:', @no_implemented].join("\n")
            ].join("\n\n")
          end
        end
      end
    end
  end
end
