require 'fitting/records/test_unit/request'

module Fitting
  class Records
    class RealizedUnit
      def initialize(realized_requests, documented_requests)
        @realized_requests = realized_requests
        @documented_requests = documented_requests
      end

      def fully_covered?
        test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.documented? }
          return false unless all_good
        end
        test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.response_documented? }
          return false unless all_good
        end
        test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.response_json_schemas? }
          return false unless all_good
        end
        test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.valid_json_schemas? }
          return false unless all_good
        end
        true
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
        @all_documented_requests ||= @documented_requests.to_hash.inject([]) do |res, tomogram_request|
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
