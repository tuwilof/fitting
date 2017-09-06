module Fitting
  class Records
    class Tested
      class Body
        attr_reader :json_schemas

        def initialize(body)
          @body = body
          @json_schemas = []
        end

        def to_s
          @body
        end
      end
    end
  end
end
