module Fitting
  class Records
    class Documented
      class Response
        attr_reader :status, :json_schemas

        def initialize(status, json_schemas)
          @status = status
          @json_schemas = json_schemas
        end
      end
    end
  end
end
