require 'fitting/records/test_unit/request'

module Fitting
  class Records
    class RealizedUnit
      def initialize(realized_requests, documented_requests)
        @realized_requests = realized_requests
        @documented_requests = documented_requests
      end

      def fully_covered?
        all_good_documented = false
        all_good_response_documented = false
        all_good_response_json_schemas = false
        all_good_valid_json_schemas = false

        test_file_paths.each do |_key, requests|
          all_good_documented = requests.all?(&:documented?)
          all_good_response_documented = requests.all?(&:response_documented?)
          all_good_response_json_schemas = requests.all?(&:response_json_schemas?)
          all_good_valid_json_schemas = requests.all?(&:valid_json_schemas?)
        end

        all_good_documented && all_good_response_documented &&
          all_good_response_json_schemas && all_good_valid_json_schemas
      end

      def test_file_paths
        return @test_file_paths if @test_file_paths

        @test_file_paths = {}
        white_unit.map do |request|
          @test_file_paths[request.test_file_path] ||= []
          @test_file_paths[request.test_file_path].push(request)
        end
        @test_file_paths
      end

      def all_documented_requests
        @all_documented_requests ||= @documented_requests.to_a.inject([]) do |res, tomogram_request|
          res.push(Fitting::Records::Documented::Request.new(tomogram_request, nil))
        end
      end

      def white_unit
        @white_unit_requests ||= @realized_requests.to_a.inject([]) do |res, tested_request|
          res.push(Fitting::Records::TestUnit::Request.new(tested_request, all_documented_requests))
        end
      end
    end
  end
end
