require 'fitting/records/documented/request'
require 'tomograph/path'

module Fitting
  class Records
    class Documented
      class Requests
        def initialize(tomogram, white_list)
          @requests = tomogram.inject([]) do |requests, tomogram_request|
            request = Fitting::Records::Documented::Request.new(tomogram_request, white_list)
            requests.push(request)
          end
        end

        def to_a
          @requests
        end
      end
    end
  end
end
