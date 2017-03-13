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

            "Fully conforming requests:\n"\
            "#{@fully_implemented}\n"\
            "Partially conforming requests:\n"\
            "#{@partially_implemented}\n"\
            "Non-conforming requests:\n"\
            "#{@no_implemented}\n"
          end
        end
      end
    end
  end
end
