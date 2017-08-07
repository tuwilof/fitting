require 'fitting/records/documented/request'
require 'tomograph/path'

module Fitting
  class Records
    class Documented
      class Requests
        def initialize(tomogram, responses)
          @requests = tomogram.inject([]) do |requests, tomogram_request|
            request = Fitting::Records::Documented::Request.new(tomogram_request)
            request.add_responses(tomogram_request['responses'], responses)
            requests.push(request)
          end
        end

        def to_a
          @requests
        end

        def join(tested_requests)
          tested_requests.to_a.map do |tested_request|
            @requests.map do |documented_request|
              next unless documented_request.method == tested_request.method &&
                          documented_request.path.match(tested_request.path.to_s)
              tested_request.join(documented_request)
              documented_request.join(tested_request)
            end
          end
        end

        def joind_white_list(white_list)
          @requests.map do |request|
            request.joind_white_list(white_list)
          end
        end

        def white
          return @white if @white
          find
          @white
        end

        def black
          return @black if @black
          find
          @black
        end

        def find
          @white = []
          @black = []
          @requests.map do |request|
             if request.white
               @white.push(request)
             else
               @black.push(request)
             end
          end
        end
      end
    end
  end
end
