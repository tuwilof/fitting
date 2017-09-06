require 'fitting/records/documented/request'
require 'tomograph/path'

module Fitting
  class Records
    class Documented
      class Requests
        def initialize(tomogram, white_list)
          @requests = tomogram.inject([]) do |requests, tomogram_request|
            request = Fitting::Records::Documented::Request.new(tomogram_request, white_list)
            request.add_responses(tomogram_request['responses'])
            requests.push(request)
          end
        end

        def to_a
          @requests
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
