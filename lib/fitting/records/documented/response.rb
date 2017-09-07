module Fitting
  class Records
    class Documented
      class Response
        attr_reader :status, :json_schemas

        def initialize(response)
          @status = response['status']
          @json_schemas = response['json_schemas']
        end
      end
    end
  end
end
