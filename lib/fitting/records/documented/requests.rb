require 'fitting/records/documented/request'
require 'tomograph/path'
require 'fitting/records/statistics'

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

        def all_count
          @requests.size
        end

        def white
          @white ||= @requests.inject([]) do |res, request|
            next res unless request.white
            res.push(request)
          end
        end

        def black
          @black ||= @requests.inject([]) do |res, request|
            next res if request.white
            res.push(request)
          end
        end

        def black_statistics_with_conformity_lists
          Fitting::Records::Statistics.new(black).statistics_with_conformity_lists
        end

        def white_statistics_with_conformity_lists
          Fitting::Records::Statistics.new(white).statistics_with_conformity_lists
        end

        def statistics_with_conformity_lists
          congratulation = 'All responses are 100% valid! Great job!' if @coverage.not_coverage.empty?

          [
            @requests.conformity_lists,
            @requests.statistics,
            @responses.statistics,
            congratulation
          ].compact.join("\n\n")
        end
      end
    end
  end
end
